require 'spec_helper'

describe "Orders" do
  describe "edit" do
    context "member" do
      before(:each) do
        member = create_member(:email=>'member@example.com')
        login('member@example.com')
        @order = Factory(:order,:name => "New Name",:address => "New Address",:email => "new@email.com",:pay_type => 'Pay on Delivery',:postal_service => 'Scud Missile', :user_id => member.id)
      end

      it "has a title" do
        visit edit_order_path(@order)
        page.should have_title('Edit Order')
      end

      it "has a update button" do
        visit edit_order_path(@order)
        page.should have_button('Update Order')
      end

      it "has a cancel update button" do
        visit edit_order_path(@order)
        page.should have_button('Cancel Update')
      end

      context "cancel update" do
        before(:each) do
          visit edit_order_path(@order)
        end

        it "does not update the attributes of the order" do
          fill_in 'Name', :with => "Edited Name"
          click_button 'Cancel Update'
          Order.last.name.should_not eq 'Edited Name'
        end
        it "redirects to the validate page" do
          click_button 'Cancel Update'
          current_path.should eq validate_order_path(@order)
        end
        it "shows no flash message" do  
          click_button 'Cancel Update'
          page.should_not have_notice
        end
      end

      context "update order" do
        before(:each) do
          visit edit_order_path(@order)
          fill_in 'Name', :with => "Edited Name"
          fill_in 'Address', :with => "Edited Address"
          fill_in 'Email', :with => "edited@email.com"
          select 'Flying Carpet', :from => 'Postal Service'
        end

        it "does not add an order to the database" do
          lambda do
            click_button 'Update Order'
          end.should change(Order,:count).by(0)
        end

        it "does not change the state of the order" do
          click_button 'Update Order'
          Order.last.aasm_state.should eq 'draft'
        end

        it "updated the attributes of the order" do
          click_button 'Update Order'
          order = Order.last
          order.name.should eq 'Edited Name'
          order.address.should eq 'Edited Address'
          order.email.should eq 'edited@email.com'
          order.pay_type.should eq Order::PAY_ON_DELIVERY 
          order.postal_service.should eq Order::FLYING_CARPET 
        end

        it "redirects back to the validate page" do
          click_button 'Update Order'
          current_path.should eq validate_order_path(@order)
        end 

        it "shows a flash message" do
          click_button 'Update Order'
          page.should have_notice('Order was successfully updated.')
        end
      end
    end

    context "admin" do
      before(:each) do
        member = create_member(:email=>'member@example.com')
        admin = create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        @order = Factory(:order,:name => "New Name",:address => "New Address",:email => "new@email.com",:pay_type => 'Pay on Delivery',:postal_service => 'Scud Missile', :user_id => member.id, :aasm_state => 'confirmed')
      end

      context "update order" do
        before(:each) do
          visit edit_order_path(@order)
        end

        it "redirects to the order show page" do
          click_button 'Update Order'
          current_path.should eq order_path(@order)
        end

        it "does not change the state of the order" do
          click_button 'Update Order'
          Order.last.aasm_state.should eq 'confirmed'
        end
      end
    end
  end
end
