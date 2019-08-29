require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"

Bundler.require
require "merit"

module Dummy
  class Application < Rails::Application
    if Rails.version.match? "5.2.+"
      config.active_record.sqlite3.represent_boolean_as_integer = true
    end

    config.i18n.enforce_available_locales = true
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end
