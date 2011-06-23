module Merit
  # This module is automatically included into all controllers.
  module ControllerMethods
    # Sets up an after_filter to update merit_actions table like:
    #
    #   class UsersController < ApplicationController
    #     grant_badges :only => %w(create follow)
    #   end
    #
    def grant_badges(*args)
      options = args.extract_options!
      after_filter(options) do |controller|
        # TODO: target_object should be configurable (now it's singularized controller name)
        target_id = params[:id]
        target_id = instance_variable_get(:"@#{controller_name.singularize}").try(:id) if target_id.nil?

        # TODO: value relies on params[:value] on the controller, should be configurable
        value = params[:value]
        MeritAction.create(
          :user_id       => current_user.try(:id),
          :action_method => action_name,
          :action_value  => value,
          :target_model  => controller_name,
          :target_id     => target_id
        )

        # Check rules in after_filter?
        if Merit.checks_on_each_request
          ::MeritBadgeRules.new.check_new_actions
          # FIXME: Now checking rules granting on each request!
          ::MeritRankRules.new.check_rank_rules
        end
      end
    end
  end
end

if defined? ActionController
  ActionController::Base.extend Merit::ControllerMethods
end