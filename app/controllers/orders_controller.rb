class OrdersController < ApplicationController
  load_and_authorize_resource

  def new
    cart = current_cart
    if cart.line_items.empty?
      redirect_to root_path, :notice => notify(:your_cart_is_empty)
      return
    end
  end
end
