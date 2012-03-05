require 'spec_helper'

describe Cart do
  it "when cart is destroyed, its line items are destroyed as well" do
    cart = Cart.create 
    book = Factory(:book)
    line_item = cart.line_items.build(:book_id=>book.id)
    line_item.save!
    lambda do
      cart.destroy
    end.should change(LineItem,:count).by(-1)
  end
end
# == Schema Information
#
# Table name: carts
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

