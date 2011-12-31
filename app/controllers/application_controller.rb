class ApplicationController < ActionController::Base
  include BasicApplicationController
  protect_from_forgery
  helper_method :pt

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = alertify(:unauthorized_access)
    if current_user
      redirect_to welcome_url
    else
      redirect_to login_url
    end
  end
end
