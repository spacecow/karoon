class LineItemsController < ApplicationController
  before_filter :load_line_item_through_cart, :only => :create
  load_and_authorize_resource

  def create
    if @line_item.save
      redirect_to @line_item.cart, :notice => t('successes.added_to_cart',:o=>t(:book),:name=>@line_item.book.title)
    end
  end

  private

    def load_line_item_through_cart
      cart = current_cart
      @line_item = cart.add_book(params[:line_item])
    end
end
