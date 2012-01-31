require 'spec_helper'

describe "Orders" do
  describe "show" do
    before(:each) do
      member = create_member(:email=>'member@example.com')
      login('member@example.com')
      @order = Factory(:order,:user_id=>member.id)
    end

    context "layout" do
      context "has a title as" do
        it "draft" do
          visit order_path(@order)
          page.should have_title('Order draft')
        end

        it "confirmed" do
          @order.order_confirmed!
          visit order_path(@order)
          page.should have_title('Order confirmed')
        end
      end

      it "has line items" do
        visit order_path(@order)
        page.should have_div('line_items')
      end
    end
  end
end
