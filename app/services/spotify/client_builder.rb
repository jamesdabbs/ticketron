module Spotify
  class ClientBuilder < Gestalt[:repository]
    def call user
      identity = repository.identity user: user, provider: 'spotify'
      raise Spotify::NotLinked unless identity

      creds = identity.data.credentials
      token = if creds.expires_at.to_i <= Time.now.to_i - 10
        refresh_token identity
      else
        creds.token
      end

      Spotify::Client.new access_token: token
    end

    private

    def refresh_token identity
      response = HTTParty.post 'https://accounts.spotify.com/api/token',
        body: {
          grant_type: 'refresh_token',
          refresh_token: identity.data.credentials.refresh_token
        },
        basic_auth: {
          username: Figaro.env.spotify_client_id!,
          password: Figaro.env.spotify_client_secret!
        }
      repository.update_credentials identity: identity, credentials: response
      response.fetch('access_token')
    end
  end
end
