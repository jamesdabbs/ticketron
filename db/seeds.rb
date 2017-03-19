Doorkeeper::Application.create! \
  name:         'Google',
  uid:          Figaro.env.google_client_id!,
  secret:       Figaro.env.google_client_secret!,
  redirect_uri: "https://oauth-redirect.googleusercontent.com/r/#{Figaro.env.google_project_id!}"

receiver = Ticketron.container.mail_receiver.with \
  handler: ->(mail) { ProcessMailJob.new.perform mail }

Dir['db/mail/*.json'].each do |path|
  puts "Handling #{path}"
  json = JSON.parse File.read path
  receiver.call ActionController::Parameters.new(json)
end
