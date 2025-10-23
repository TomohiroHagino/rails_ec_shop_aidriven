source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 2.1'
# Use Puma as the app server
gem 'puma', '>= 5.0'
# The modern asset pipeline for Rails
gem 'propshaft'
# Use SCSS for stylesheets
gem 'dartsass-rails'
# Build JSON APIs with ease
gem 'jbuilder'
# Use Devise for authentication
gem 'devise', github: 'heartcombo/devise', branch: 'main'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # Debugging
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  # RSpec for testing
  gem 'rspec-rails', '~> 7.0'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'database_cleaner-active_record'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ windows jruby ]

gem "jsbundling-rails", "~> 1.3"
