module Talent
  # This module is automatically included into all controllers.
  module ControllerMethods
    # Sets up an after_filter to update talent_actions table like:
    #
    #   class UsersController < ApplicationController
    #     grant_badges :only => %w(create follow)
    #   end
    #
    def grant_badges(*args)
      options = args.extract_options!
      self.after_filter(options) do |controller|
        target_id = controller.params[:id]
        # TODO: Created object should be configurable (now it's singularized controller name)
        target_id = controller.instance_variable_get(:"@#{controller.controller_name.singularize}").try(:id) if target_id.nil?
        TalentAction.create(
          :user_id       => current_user.try(:id),
          :action_method => action_name,
          :action_value  => nil, # TODO
          :target_model  => controller.controller_name,
          :target_id     => target_id
        )

        # Check rules in after_filter?
        # FIXME: why ::TalentRules.new instead of current_rules?
        ::TalentRules.new.check_new_actions if Talent.checks_on_each_request
      end
    end

    # Initialize and cache rules
    def current_rules
      @current_rules ||= ::TalentRules.new
    end
  end
end

if defined? ActionController
  ActionController::Base.extend Talent::ControllerMethods
end