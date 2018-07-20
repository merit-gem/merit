require 'merit/rule'
require 'merit/rules_badge_methods'
require 'merit/rules_points_methods'
require 'merit/rules_rank_methods'
require 'merit/rules_matcher'
require 'merit/controller_extensions'
require 'merit/model_additions'
require 'merit/judge'
require 'merit/reputation_change_observer'
require 'merit/sash_finder'
require 'merit/base_target_finder'
require 'merit/target_finder'
require 'merit/models/base/sash'
require 'merit/models/base/badges_sash'

module Merit
  def self.setup
    @config ||= Configuration.new
    yield @config if block_given?
  end

  # Check rules on each request
  def self.checks_on_each_request
    @config.checks_on_each_request
  end

  # # Define ORM
  def self.orm
    @config.orm || :active_record
  end

  # Define user_model_name
  def self.user_model
    @config.user_model_name.constantize
  end

  # Define current_user_method
  def self.current_user_method
    @config.current_user_method ||
      "current_#{@config.user_model_name.downcase}".to_sym
  end

  def self.observers
    @config.observers
  end

  # @param class_name [String] The string version of observer class
  def self.add_observer(class_name)
    @config.add_observer(class_name)
  end

  def self.upgrade_target_data_warning
    Rails.logger.warn '[merit] Missing column: target_data. Run `rails ' \
                      'generate merit:upgrade` and `rake db:migrate` to add it.'
  end

  class Configuration
    attr_accessor :checks_on_each_request, :orm, :user_model_name, :observers,
                  :current_user_method

    def initialize
      @checks_on_each_request = true
      @orm = :active_record
      @user_model_name = 'User'
      @observers = []
    end

    def add_observer(class_name)
      @observers << class_name
    end
  end

  setup
  add_observer('Merit::ReputationChangeObserver')

  class BadgeNotFound < StandardError; end
  class RankAttributeNotDefined < StandardError; end

  class Engine < Rails::Engine
    config.app_generators.orm Merit.orm

    initializer 'merit.controller' do |app|
      extend_orm_with_has_merit
      require_models
      ActiveSupport.on_load(action_controller_hook) do
        begin
          # Load app rules on boot up
          Merit::AppBadgeRules = Merit::BadgeRules.new.defined_rules
          Merit::AppPointRules = Merit::PointRules.new.defined_rules
          include Merit::ControllerExtensions
        rescue NameError => e
          # Trap NameError if installing/generating files
          raise e unless
            e.to_s =~ /uninitialized constant Merit::(BadgeRules|PointRules)/
        end
      end
    end

    def require_models
      require 'merit/models/base/sash'
      require 'merit/models/base/badges_sash'
      require "merit/models/#{Merit.orm}/merit/activity_log"
      require "merit/models/#{Merit.orm}/merit/badges_sash"
      require "merit/models/#{Merit.orm}/merit/sash"
      require "merit/models/#{Merit.orm}/merit/score"
    end

    def extend_orm_with_has_merit
      if Object.const_defined?('ActiveRecord')
        ActiveRecord::Base.send :include, Merit
      end
      if Object.const_defined?('Mongoid')
        Mongoid::Document.send :include, Merit
      end
    end

    def action_controller_hook
      if Rails.application.config.api_only
        :action_controller_api
      else
        :action_controller_base
      end
    end
  end
end
