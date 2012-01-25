class OrdersController < ApplicationController
  skip_load_resource :only => :create
  load_and_authorize_resource

  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to root_path, :notice => notify(:your_cart_is_empty)
      return
    end

    if(last_order = current_user.orders.last)
      @order.copy(last_order)
    end
  end

  def create
    @order = current_user.orders.build(params[:order])
    @order.transfer_line_items_from_cart(current_cart)
    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      flash[:notice] = created_state(:order,@order.aasm_state) 
      redirect_to validate_order_path(@order)
    else
      render :new
    end
  end

  def confirm
    if params[:edit_button]
      redirect_to edit_order_path(@order)
    else
      @order.order_confirmed! unless params[:cancel_button]
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @order.update_attributes(params[:order])
      redirect_to root_path
    else
      render :edit
    end
  end
end
