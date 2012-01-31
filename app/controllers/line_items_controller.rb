class LineItemsController < ApplicationController
  before_filter :load_line_item_through_cart, :only => :create
  load_and_authorize_resource

  def create
    if @line_item.save
      if params[:line_item][:quantity] == "1"
        flash[:notice] = t('successes.added_to_cart',:o=>t(:book),:name=>@line_item.book.title)
      else
        flash[:notice] = t('successes.added_to_cart_pl',:i=>params[:line_item][:quantity],:o=>t(:books),:name=>@line_item.book.title)
      end
      redirect_to @line_item.cart
    end
  end

  def destroy
    cart = @line_item.cart
    if @line_item.quantity == 1
      flash[:notice] = t('successes.removed_from_cart',:o=>t(:book),:name=>@line_item.book.title)
    else
      flash[:notice] = t('successes.removed_from_cart_pl',:i=>@line_item.quantity,:o=>t(:books),:name=>@line_item.book.title)
    end
    @line_item.destroy
    redirect_to cart
  end

  private

    def load_line_item_through_cart
      cart = current_cart
      @line_item = cart.add_book(params[:line_item])
    end
end
