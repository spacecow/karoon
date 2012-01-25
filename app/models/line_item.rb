class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :cart
  belongs_to :order

  attr_accessible :book_id, :quantity

  validates_presence_of :cart_id, :on => :create, :unless => :order_id?
  #validates_presence_of :cart_id, :unless => :order_id?
  #validates_presence_of :order_id, :unless => :cart_id?
  validates_presence_of :book_id, :quantity

  before_save :set_item_price

  def item_price(riel)
    riel ? price.to_i*10 : price.to_i
  end
  def total_price(riel)
    item_price(riel)*quantity 
  end

  private

    def set_item_price
      self.price = book.regular_price 
    end
end
