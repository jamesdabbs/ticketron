module Spotify
  NotLinked = Class.new Error

  class ClientBuilder < Gestalt[:repository, :http]
    def call user
      auth = repository.find_auth user: user, provider: Identity::Spotify
      raise Spotify::NotLinked unless auth

      creds = auth.credentials
      token = if creds.expires_at <= 30.seconds.from_now.to_i
        refresh_token user: user, credentials: creds
      else
        creds.token
      end

      Spotify::Client.new access_token: token
    end

    private

    def refresh_token user:, credentials:
      response = http.call :post, 'https://accounts.spotify.com/api/token',
        body: {
          grant_type:    'refresh_token',
          refresh_token: credentials.refresh_token
        },
        basic_auth: {
          username: Figaro.env.spotify_client_id!,
          password: Figaro.env.spotify_client_secret!
        }

      response['expires_at'] = (Time.now + response['expires_in']).to_i

      repository.update_credentials \
        provider:    Identity::Spotify,
        user:        user,
        credentials: {
          'token'         => response.fetch('access_token'),
          'refresh_token' => credentials.refresh_token,
          'expires_at'    => (Time.now + response.fetch('expires_in')).to_i,
          'expires'       => true,
          'scope'         => response.fetch('scope')
        }

      response.fetch('access_token')
    end
  end
end
