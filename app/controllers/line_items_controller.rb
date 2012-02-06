class LineItemsController < ApplicationController
  before_filter :load_line_item_through_cart, :only => :create
  load_and_authorize_resource

  def create
    if @line_item.save
      flash[:notice] = added_to_cart(:book, @line_item.book_title, params[:line_item][:quantity].to_i)
      redirect_to @line_item.cart
    end
  end

  def destroy
    cart = @line_item.cart
    flash[:notice] = removed_from_cart(:book, @line_item.book_title, @line_item.quantity)
    @line_item.destroy
    redirect_to cart
  end

  private

    def load_line_item_through_cart
      cart = current_cart
      @line_item = cart.add_book(params[:line_item])
    end
end
