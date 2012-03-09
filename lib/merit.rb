require 'merit/core_extensions'
require 'merit/rule'
require 'merit/rules_badge'
require 'merit/rules_points'
require 'merit/rules_rank'
require 'merit/controller_extensions'
require 'merit/model_additions'

module Merit
  # Check rules on each request
  mattr_accessor :checks_on_each_request
  @@checks_on_each_request = true

  # Define ORM
  mattr_accessor :orm
  @@orm = :active_record

  # Load configuration from initializer
  def self.setup
    yield self
  end

  class Engine < Rails::Engine
    initializer 'merit.controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        # Require Merit models
        require "merit/models/#{Merit.orm}/badge"
        require "merit/models/#{Merit.orm}/merit_action"
        require "merit/models/#{Merit.orm}/sash"
        if @@orm == :active_record
          require "merit/models/#{Merit.orm}/badges_sash"
        end

        include Merit::ControllerExtensions
      end
    end
  end
end