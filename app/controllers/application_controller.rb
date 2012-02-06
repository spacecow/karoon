class ApplicationController < ActionController::Base
  include BasicApplicationController
  protect_from_forgery
  helper_method :pt,:current_user,:currency_in_riel?,:currency,:current_cart,:pl
  before_filter :load_new_search, :set_language

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = alertify(:unauthorized_access)
    flash[:alert] = exception.message
    if current_user
      redirect_to welcome_url
    else
      session[:original_url] = request.path  
      redirect_to login_url
    end
  end

  def currency
    session[:currency] ||= Setting.singleton.currency
  end
  def currency_in_riel?
    currency == Setting::RIEL
  end

  private

    def current_cart
      Cart.find(session[:cartid])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cartid] = cart.id
      cart
    end

    def load_new_search
      @new_search = Search.new
    end

    def set_language
      session[:language] = params[:language].to_sym if params[:language]
      I18n.locale = session[:language] || I18n.default_locale
    end
end
