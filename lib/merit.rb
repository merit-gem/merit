require 'zeitwerk'

module Merit
  def self.setup
    @config ||= Configuration.new
    yield @config if block_given?
  end

  # Check rules on each request
  def self.checks_on_each_request
    @config.checks_on_each_request
  end

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
      config.to_prepare do
        ActiveSupport.on_load(:active_record) { include Merit }
        ActiveSupport.on_load(app.config.api_only ? :action_controller_api : :action_controller_base) do
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
    end
  end
end

loader = Zeitwerk::Loader.for_gem
loader.setup
loader.eager_load
