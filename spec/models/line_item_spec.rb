require 'spec_helper'

describe LineItem do
  context "#cart_id" do
    it "cannot be blank on creation" do
      item = LineItem.create
      item.errors.messages[:cart_id].join.should eq "can't be blank"
    end
    it "must be present" do
      item = Factory(:line_item,:cart_id=>1)
      item.errors.messages[:cart_id].should be_nil
    end
  end
end
# == Schema Information
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  book_id    :integer(4)
#  cart_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  quantity   :integer(4)      default(1)
#  order_id   :integer(4)
#  price      :string(255)
#

