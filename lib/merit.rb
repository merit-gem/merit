require 'merit/rule'
require 'merit/rules_badge_methods'
require 'merit/rules_points_methods'
require 'merit/rules_rank_methods'
require 'merit/rules_matcher'
require 'merit/controller_extensions'
require 'merit/model_additions'
require 'merit/judge'
require 'merit/sash_finder'
require 'merit/base_target_finder'
require 'merit/target_finder'

module Merit
  def self.setup
    @config ||= Configuration.new
    yield @config if block_given?
  end

  # Define user_model_name
  def self.user_model
    @config.user_model_name.constantize
  end

  # Define current_user_method
  def self.current_user_method
    @config.current_user_method || "current_#{@config.user_model_name.downcase}".to_sym
  end

  def self.method_missing(method_name, *args, &block)
    @config.respond_to?(method_name) ?
      @config.send(method_name, *args, &block) : super
  end

  class Configuration
    attr_accessor :checks_on_each_request,
      :orm, :user_model_name, :current_user_method, 
      :awarding_observers
    def initialize
      @checks_on_each_request = true
      @orm = :active_record
      @user_model_name = 'User'
      @awarding_observers = []
    end
  end

  setup

  class BadgeNotFound < Exception; end
  class RankAttributeNotDefined < Exception; end

  class Engine < Rails::Engine
    config.app_generators.orm Merit.orm

    initializer 'merit.controller' do |app|
      if Merit.orm == :active_record
        require 'merit/models/active_record/merit/activity_log'
        require 'merit/models/active_record/merit/badges_sash'
        require 'merit/models/active_record/merit/sash'
        require 'merit/models/active_record/merit/score'
      elsif Merit.orm == :mongoid
        require 'merit/models/mongoid/sash'
      end

      ActiveSupport.on_load(:action_controller) do
        begin
          # Load application defined rules on application boot up
          ::Merit::AppBadgeRules = ::Merit::BadgeRules.new.defined_rules
          ::Merit::AppPointRules = ::Merit::PointRules.new.defined_rules
          include Merit::ControllerExtensions
        rescue NameError => e
          # Trap NameError if installing/generating files
          raise e unless e.to_s =~ /uninitialized constant Merit::BadgeRules/
        end
      end
    end
  end
end
