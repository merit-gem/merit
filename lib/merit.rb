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
      # Merit.orm now set
      if Merit.orm == :active_record
        # This line to fix rails g merit:install raise "uninitialized constant ActiveRecord" with Mongoid projects.
        if Module.const_defined?("ActiveRecord")
          require "merit/models/#{Merit.orm}/sash"
          require "merit/models/#{Merit.orm}/badges_sash"
        end
      elsif Merit.orm == :mongoid
        require "merit/models/#{Merit.orm}/sash"
      end

      ActiveSupport.on_load(:action_controller) do
        include Merit::ControllerExtensions
      end
    end
  end
end
