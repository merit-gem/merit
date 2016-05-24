class ApplicationController < ActionController::Base
  protect_from_forgery

  include Merit::ControllerExtensions

  def current_user
    @current_user ||= User.first
  end
end
