# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"

# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require
require "merit"

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.2 if ENV["RAILS_VERSION"] =~ /^5.2/
    config.api_only = true
    config.i18n.enforce_available_locales = true
    config.encoding = "utf-8"
  end
end
