class LineItemsController < ApplicationController
  load_and_authorize_resource

  def create
p "!!!!!!!!!!!!!!!!!!!"
    redirect_to @line_item.cart
  end
end
