require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"

Bundler.require
require "merit"

module Dummy
  class Application < ::Rails::Application
    config.load_defaults Rails.version[0..2]
    config.i18n.enforce_available_locales = true
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end
