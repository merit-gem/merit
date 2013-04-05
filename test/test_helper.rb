# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
RUBYOPT="-w $RUBYOPT"

require 'simplecov'
SimpleCov.adapters.define 'rubygem' do
  # Add app to Merit group
  # https://github.com/colszowka/simplecov/pull/104
  add_group 'Merit', 'lib'
  add_group 'DummyApp', 'test/dummy'
  add_filter 'test/dummy/config/initializers'
end
SimpleCov.start 'rubygem' if ENV["COVERAGE"]

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require "rails/test_help"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require 'mocha/setup'

ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
