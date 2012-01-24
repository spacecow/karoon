class Order < ActiveRecord::Base
  include AASM

  PAYMENT_TYPES = ["Purchase Order"] #Check, Credit Card

  belongs_to :user
  validates_presence_of :name, :address, :email, :user_id
  validates :pay_type, :inclusion => PAYMENT_TYPES

  attr_accessible :name, :address, :email, :pay_type

  aasm_initial_state :draft
  aasm_state :draft

  def copy(order)
    self.name     = order.name
    self.address  = order.address
    self.email    = order.email
    self.pay_type = order.pay_type 
  end
end
