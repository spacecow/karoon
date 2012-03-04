require 'spec_helper'

describe "Orders, index:", focus:true do
  context "member links to" do
    before(:each) do
      own   = login_member
      @order = Factory(:order,user_id:own.id)
      book  = Factory(:book,title:'A new book')
      Factory(:line_item, order_id:@order.id, book_id:book.id)
      visit orders_path
    end

    it "the order page" do
      row(1,:orders).click_link('A new book')
      current_path.should eq order_path(@order)
    end

    it "the edit order page" do
      row(1,:orders).click_link('Edit')
      current_path.should eq edit_order_path(@order)
    end
  end
end
