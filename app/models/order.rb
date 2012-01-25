class Order < ActiveRecord::Base
  include AASM

  has_many :line_items

  PAYMENT_TYPES = ["Purchase Order"] #Check, Credit Card

  belongs_to :user
  validates_presence_of :name, :address, :email, :user_id
  validates :pay_type, :inclusion => PAYMENT_TYPES

  attr_accessible :name, :address, :email, :pay_type

  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :confirmed

  aasm_event :order_confirmed do
    transitions :from => :draft, :to => :confirmed
  end

  def copy(order)
    self.name     = order.name
    self.address  = order.address
    self.email    = order.email
    self.pay_type = order.pay_type 
  end

  def total_price(riel)
    line_items.to_a.sum{|e| e.total_price(riel)} 
  end

  def transfer_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      #item.order_id = id
      line_items << item
    end 
  end
end
