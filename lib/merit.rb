require 'merit/core_extensions'
require 'merit/rule'
require 'merit/rules_badge'
require 'merit/rules_points'
require 'merit/rules_rank'
require 'merit/controller_extensions'
require 'merit/model_additions'
# ActiveRecord model relations
require 'merit/models/active_record/badge'
require 'merit/models/active_record/badges_sash'
require 'merit/models/active_record/merit_action'
require 'merit/models/active_record/sash'

module Merit
  # Check rules on each request
  mattr_accessor :checks_on_each_request
  @@checks_on_each_request = true

  # Load configuration from initializer
  def self.setup
    yield self
  end

  class Engine < Rails::Engine
    initializer 'merit.controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Merit::ControllerExtensions
      end
    end
  end
end