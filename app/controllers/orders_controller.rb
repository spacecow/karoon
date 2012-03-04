class OrdersController < ApplicationController
  skip_load_resource :only => [:create,:index]
  load_and_authorize_resource

  def show
  end

  def index
    @orders = Order.scoped
    @orders = @orders.where(user_id:current_user.id) if cannot? :check, Order
  end

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
    redirect_to current_cart and return if params[:cancel_button]
    @order = current_user.orders.build(params[:order])
    if @order.save
      @order.transfer_line_items_from_cart(current_cart)
      Cart.destroy(session[:cartid])
      session[:cartid] = nil
      flash[:notice] = created(:order_draft) 
      redirect_to validate_order_path(@order)
    else
      @cart = current_cart
      render :new
    end
  end

  def confirm
    if params[:edit_button]
      redirect_to edit_order_path(@order)
    else
      if params[:cancel_button]
        flash[:notice] = canceled(:your_order) + " " + notify(:saved_as_draft_in_my_orders)
        redirect_to root_path
      else
        flash[:notice] = confirmed(:your_order) + " " + notify(:email_has_been_sent_about_your_purchase) 
        @order.order_confirmed! 
        redirect_to @order 
      end
    end
  end

  def edit
  end

  def update
    redirect_to validate_order_path(@order) and return if params[:cancel_button]
    if @order.update_attributes(params[:order])
      flash[:notice] = updated(:order)
      if @order.aasm_state == 'draft'
        redirect_to validate_order_path(@order) 
      else
        redirect_to @order 
      end
    else
      render :edit
    end
  end

  def check
  end
end
