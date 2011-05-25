class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.current_user
    @current_user ||= User.first
  end
end
