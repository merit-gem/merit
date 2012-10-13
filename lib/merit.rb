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

  # Define user_model_name
  mattr_accessor :user_model_name
  @@user_model_name = "User"
  def self.user_model
    @@user_model_name.constantize
  end

  # Define current_user_method
  mattr_accessor :current_user_method
  def self.current_user_method
    @@current_user_method || "current_#{@@user_model_name.downcase}".to_sym
  end


  # Load configuration from initializer
  def self.setup
    yield self
  end

  class Engine < Rails::Engine
    config.app_generators.orm Merit.orm

    initializer 'merit.controller' do |app|
      if Merit.orm == :active_record
        require 'merit/models/active_record/sash'
        require 'merit/models/active_record/badges_sash'
        require 'merit/models/active_record/merit/score'
      elsif Merit.orm == :mongoid
        require "merit/models/mongoid/sash"
      end

      ActiveSupport.on_load(:action_controller) do
        include Merit::ControllerExtensions
      end
    end
  end
end
