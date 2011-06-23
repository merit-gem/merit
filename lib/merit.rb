require 'merit/core_extensions'
require 'merit/rule'
require 'merit/rules_badge'
require 'merit/rules_rank'
require 'merit/controller_additions'
require 'merit/model_additions'

module Merit
  # Check rules on each request
  mattr_accessor :checks_on_each_request
  @@checks_on_each_request = true

  # Load configuration from initializer
  def self.setup
    yield self
  end

  class Engine < Rails::Engine
  end
end