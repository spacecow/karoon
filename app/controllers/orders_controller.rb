class OrdersController < ApplicationController
  skip_load_resource :only => :create
  load_and_authorize_resource

  def show
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
    @order = current_user.orders.build(params[:order])
    @order.transfer_line_items_from_cart(current_cart)
    if @order.save
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
        flash[:notice] = canceled(:your_order)
        redirect_to root_path
      else
        flash[:notice] = confirmed(:your_order) + " " + t('messages.email_has_been_sent_about',:o=>t(:purchase).downcase) 
        @order.order_confirmed! 
        redirect_to @order 
      end
    end
  end

  def edit
  end

  def update
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
end
