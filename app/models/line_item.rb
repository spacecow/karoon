class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :cart
  belongs_to :order

  attr_accessible :book_id, :quantity

  validates_presence_of :cart_id, :book_id, :quantity

  def price(riel); book.price(riel)*quantity end
end
