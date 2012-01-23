class ApplicationController < ActionController::Base
  include BasicApplicationController
  protect_from_forgery
  helper_method :pt,:current_user,:currency_in_riel?,:currency,:current_cart
  before_filter :load_new_search

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = alertify(:unauthorized_access)
    if current_user
      redirect_to welcome_url
    else
      session[:original_url] = request.path  
      redirect_to login_url
    end
  end

  def created_adv(o,name)
    t("successes.created_adv",:o=>t(o),:name=>name)
  end

  def deleted_adv(o,name)
    t("successes.deleted_adv",:o=>t(o),:name=>name) 
  end
  def updated_adv(o,name)
    t("successes.updated_adv",:o=>t(o),:name=>name) 
  end

  def currency
    session[:currency] ||= Setting.singleton.currency
  end
  def currency_in_riel?
    currency == Setting::RIEL
  end

  private

    def current_cart
      @cart ||= Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
      @cart
    end

    def load_new_search
      @new_search = Search.new
    end
end
