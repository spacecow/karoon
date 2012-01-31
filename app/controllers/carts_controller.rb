class CartsController < ApplicationController
  before_filter :load_cart

  def show
    return if unauthorize_access_to_someone_elses_cart?(:show)
  end

  def update
    return if unauthorize_access_to_someone_elses_cart?(:update)
    redirect_to new_order_path and return if params[:checkout_button] 
    if @cart.update_attributes(params[:cart])
      redirect_to @cart, :notice => updated(:cart)
    end
  end

  def destroy
    return if unauthorize_access_to_someone_elses_cart?(:destroy)
    @cart.destroy
    session[:cartid] = nil
    redirect_to cart_path(current_cart), :notice => emptied(:your_cart)
  end

  private

    def load_cart
      begin
        @cart = Cart.find(params[:id]) 
      rescue ActiveRecord::RecordNotFound
        logger.error "Attempt to access invalid cart #{params[:id]}"
        redirect_to welcome_url, :alert => alertify(:invalid_cart)
        return
      end
    end

    def unauthorize_access_to_someone_elses_cart?(action)
      if @cart != current_cart and cannot?(action, @cart)
        logger.error "Attempt to access other person's cart #{params[:id]}"
        redirect_to welcome_url, :alert => alertify(:invalid_cart)
        return true
      end
      false
    end
end
