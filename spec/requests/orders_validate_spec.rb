require 'spec_helper'

describe "Orders" do
  describe "validate" do
    it "send email to user after confirmation"

    before(:each) do
      Setting.singleton.update_attribute(:currency,Setting::RIAL)
      member = create_member(:email=>'member@example.com')
      login('member@example.com')
      book = Factory(:book,:title=>'Funny Title',:regular_price=>'1234')
      @order = Factory(:order,:name => "New Name",:address => "New Address",:email => "new@email.com",:pay_type => 'Pay on Delivery',:postal_service => 'Scud Missile',:user_id=>member.id)
      @order.line_items.create!(:book_id=>book.id,:quantity=>2)
    end

    context "layout" do
      it "should have a title" do
        visit validate_order_path(@order)
        page.should have_title('Confirm Order')
      end
      it "should have a cancel button" do
        visit validate_order_path(@order)
        form(:confirm_order).should have_button('Cancel Order')
      end
      it "should have an edit button" do
        visit validate_order_path(@order)
        form(:confirm_order).should have_button('Edit Order')
      end
      it "should have a confirm button" do
        visit validate_order_path(@order)
        form(:confirm_order).should have_button('Confirm Order')
      end

      context "list books" do
        it "one" do
          visit validate_order_path(@order)
          div('line_item',0).div('info').should have_content('Funny Title')
          div('line_item',0).div('price').should have_content('12340 Rial x 2 = 24680 Rial')
          div('line_items').div('total').should have_content('Total: 24680 Rial')
        end
        it "two" do
          book2 = Factory(:book,:title=>'Funnier Title',:regular_price=>"2345")
          @order.line_items.create!(:book_id=>book2.id,:quantity=>1)
          visit validate_order_path(@order)
          div('line_item',1).div('info').should have_content('Funnier Title')
          div('line_item',1).div('price').should have_content('23450 Rial x 1 = 23450 Rial')
          div('line_items').div('total').should have_content('Total: 48130 Rial')
        end
      end
    
      it "show order info" do
        visit validate_order_path(@order)
        div('order',0).div('name').should have_content('Name: New Name')
        div('order',0).div('address').should have_content('Address: New Address')
        div('order',0).div('email').should have_content('Email: new@email.com')
        div('order',0).div('pay_type').should have_content('Pay Type: Pay on Delivery')
        div('order',0).div('postal_service').should have_content('Postal Service: Scud Missile')
      end
    end

    context "cancel confirmation of order" do
      before(:each) do
        visit validate_order_path(@order)
        form(:confirm_order).click_button 'Cancel'
      end

      it "status is unchanged" do
        Order.last.aasm_state.should eq 'draft'
      end

      it "redirect to the root page" do
        current_path.should eq root_path
      end

      it "shows a flash message" do
        page.should have_notice("Your order was canceled. It is saved as 'draft' in 'My Orders'.")
      end
    end

    context "edit order information" do
      before(:each) do
        visit validate_order_path(@order)
        form(:confirm_order).click_button 'Edit'
      end

      it "status is unchanged" do
        Order.last.aasm_state.should eq 'draft'
      end

      it "redirect to the edit order page" do
        current_path.should eq edit_order_path(@order)
      end
    end

    context "confirm order" do
      before(:each) do
        visit validate_order_path(@order)
        form(:confirm_order).click_button 'Confirm'
      end
      
      it "status is changed to 'confirmed'" do
        Order.last.aasm_state.should eq 'confirmed'
      end

      it "redirect to the order show page" do
        current_path.should eq order_path(@order) 
      end

      it "shows a flash message" do
        page.should have_notice('Your order has been confirmed. An email has been sent to you with information about your purchase.')
      end
    end
  end
end
