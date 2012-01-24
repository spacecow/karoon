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
