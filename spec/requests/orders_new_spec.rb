require 'spec_helper'

describe "Orders" do
  describe "new" do
    before(:each) do
      @member = create_member(:email=>'member@example.com')
      login('member@example.com')
      cart = Cart.last
      book = Factory(:book)
      @item = cart.line_items.create!(:book_id=>book.id)
    end
    it "must be logged in and have a line item in the cart" do
      visit new_order_path
      current_path.should eq new_order_path
    end

    context "layout" do
      it "tile is set" do
        visit new_order_path
        page.should have_title('New Order')
      end

      context "no previous order exists" do
        it "default: no order is filled in" do
          visit new_order_path
          find_field('Name').value.should be_nil
          find_field('Address').value.should be_empty
          find_field('Email').value.should be_nil
          options('Pay Type').should eq 'Purchase Order'
          selected_value('Pay Type').should be_nil
        end
      end

      context "a previous order exists" do
        it "new order is filled in" do
          Factory(:order,:user_id=>@member.id,:name=>'Last Name',:address=>'Last Address',:email=>'Last Email',:pay_type=>'Purchase Order')
          visit new_order_path
          find_field('Name').value.should eq 'Last Name'
          find_field('Address').value.should eq 'Last Address'
          find_field('Email').value.should eq 'Last Email'
          selected_value('Pay Type').should eq 'Purchase Order'
        end
      end
    end

    context "create order" do
      before(:each) do
        visit new_order_path
        fill_in 'Name', :with => "New Name"
        fill_in 'Address', :with => "New Address"
        fill_in 'Email', :with => "new@email.com"
        select 'Purchase Order', :from => 'Pay Type' 
      end

      it "saves the order to the database" do 
        lambda do
          click_button 'Create Order'
        end.should change(Order,:count).by(1)
      end

      it "transfers the line items to the order" do
        click_button 'Create Order'
        Order.last.line_items.should_not be_empty
        Order.last.line_items.should eq [@item]
      end

      it "the cart gets destroyed" do
        lambda do
          click_button 'Create Order'
        end.should change(Cart,:count).by(-1) 
      end

      it "redirects to the create page" do
        click_button 'Create Order'
        current_path.should eq orders_path
      end

      it "shows a flash message of creating a draft" do
        click_button 'Create Order'
        page.should have_notice("Order draft was successfully created.") 
      end

      it "default state is 'draft'" do
        click_button 'Create Order' 
        Order.last.aasm_state.should eq 'draft'
      end

      context "error:" do
        it "name must be present" do
          fill_in 'Name', :with => ""
          click_button 'Create Order'
          li(:name).should have_blank_error 
        end

        it "address must be present" do
          fill_in 'Address', :with => ""
          click_button 'Create Order'
          li(:address).should have_blank_error 
        end

        it "email must be present" do
          fill_in 'Email', :with => ""
          click_button 'Create Order'
          li(:email).should have_blank_error 
        end
      end
    end
  end
end
