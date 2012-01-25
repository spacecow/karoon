class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :cart
  belongs_to :order

  attr_accessible :book_id, :quantity

  validates_presence_of :cart_id, :on => :create, :unless => :order_id?
  #validates_presence_of :cart_id, :unless => :order_id?
  #validates_presence_of :order_id, :unless => :cart_id?
  validates_presence_of :book_id, :quantity

  def book_price(riel) book.price(riel) end
  def price(riel); book_price(riel)*quantity end
end
