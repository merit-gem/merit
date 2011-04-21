module Talent
  # This module is automatically included into all controllers.
  module ControllerMethods
    # Sets up a before filter to update talent_actions table
    #
    #   class UsersController < ApplicationController
    #     grant_badges :only => %w(create follow)
    #   end
    #
    def grant_badges(*args)
      # Initialize rules
      ::TalentRules.new(current_user) # FIXME: debería ser Singleton?

      options = args.extract_options!
      self.before_filter(options) do |controller|
        TalentAction.create(
          :user_id       => ApplicationController.current_user.try(:id),
          :action_method => action_name,
          :action_value  => nil, # FIXME: Aún no implementado
          :target_model  => controller.controller_name,
          :target_id     => controller.params[:id]
        )
      end
    end
  end
end

if defined? ActionController
  ActionController::Base.extend Talent::ControllerMethods
end