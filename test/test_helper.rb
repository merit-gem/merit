# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
RUBYOPT="-w $RUBYOPT"

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.adapters.define 'rubygem' do
    # Add app to Merit group
    # https://github.com/colszowka/simplecov/pull/104
    add_group 'Merit', 'lib'
    add_group 'DummyApp', 'test/dummy'
    add_filter 'test/dummy/config/initializers'
  end
  SimpleCov.start 'rubygem'
end


require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require 'capybara/rails'
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

Merit.orm = :active_record if Merit.orm.nil?

def active_record_orm?
  Merit.orm == :active_record
end

def mongoid_orm?
  Merit.orm == :mongoid
end

require "orm/#{Merit.orm}"

# TODO: tests loads active record and mongoid models in one model
# from lib folder and mix methods from two orms. It is ugly hack,
# but I can't find another solution. Need advise.
if mongoid_orm?
  Merit.send(:remove_const, :ActivityLog)
  Merit.send(:remove_const, :BadgesSash)
  Merit.send(:remove_const, :Sash)
  Merit.send(:remove_const, :Score)
end

require "merit/models/#{Merit.orm}/merit/activity_log"
require "merit/models/#{Merit.orm}/merit/badges_sash"
require "merit/models/#{Merit.orm}/merit/sash"
require "merit/models/#{Merit.orm}/merit/score"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }