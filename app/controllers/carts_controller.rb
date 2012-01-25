class CartsController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => :show

  def show
    begin
      @cart = Cart.find(params[:id]) 
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to books_url, :alert => alertify(:invalid_cart)
    end
  end

  def update
    redirect_to new_order_path and return if params[:checkout_button] 
    if @cart.update_attributes(params[:cart])
      redirect_to @cart, :notice => updated(:cart)
    end
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_url, :notice => notify(:your_cart_is_currently_empty)
  end
end
