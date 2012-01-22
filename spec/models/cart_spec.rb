require 'spec_helper'

describe Cart do
  it "when cart is destroyed, its line items are destroyed as well" do
    cart = Cart.create 
    line_item = cart.line_items.build(:book_id=>1)
    line_item.user_id = 1 
    line_item.save!
    lambda do
      cart.destroy
    end.should change(LineItem,:count).by(-1)
  end
end
