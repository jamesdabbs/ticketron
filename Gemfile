source 'https://rubygems.org'
ruby '2.4.0'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'

gem 'bootstrap_form'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'twitter-bootstrap-rails'
gem 'uglifier', '>= 1.3.0'

gem 'devise'
gem 'devise-doorkeeper'
gem 'doorkeeper'
gem 'dry-struct'
gem 'figaro'
gem 'fuzzy_match'
gem 'gestalt', github: 'jamesdabbs/gestalt'
gem 'google-api-client', '0.8.2', require: 'google/api_client'
gem 'httparty'
gem 'levenshtein'
gem 'mechanize'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-spotify'
gem 'pry-rails'
gem 'sidekiq'
gem 'spotify-client'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'rspec-given'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
  gem 'zonebie'
end

group :production do
  gem 'rollbar'
end
