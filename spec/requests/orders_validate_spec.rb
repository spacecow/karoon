require 'spec_helper'

describe "Orders", :focus=>true do
  describe "create" do
    before(:each) do
      Setting.singleton.update_attribute(:currency,Setting::RIEL)
      member = create_member(:email=>'member@example.com')
      login('member@example.com')
      book = Factory(:book,:title=>'Funny Title',:regular_price=>'1234')
      @order = Factory(:order,:name => "New Name",:address => "New Address",:email => "new@email.com",:pay_type => 'Purchase Order',:user_id=>member.id)
      @order.line_items.create!(:book_id=>book.id,:quantity=>2)
    end

    context "layout" do
      it "should have a title" do
        visit validate_order_path(@order)
        page.should have_title('Confirm Order')
      end
      it "should have a cancel button" do
        visit validate_order_path(@order)
        form(:confirm_order).should have_button('Cancel')
      end
      it "should have a confirm button" do
        visit validate_order_path(@order)
        form(:confirm_order).should have_button('Confirm')
      end

      context "list books" do
        it "one" do
          visit validate_order_path(@order)
          div('line_item',0).should have_content('Funny Title (12340 Riel) x 2 = 24680 Riel')
          div('total').should have_content('Total: 24680 Riel')
        end
        it "two" do
          book2 = Factory(:book,:title=>'Funnier Title',:regular_price=>"2345")
          @order.line_items.create!(:book_id=>book2.id,:quantity=>1)
          visit validate_order_path(@order)
          div('line_item',0).should have_content('Funny Title (12340 Riel) x 2 = 24680 Riel')
          div('line_item',1).should have_content('Funnier Title (23450 Riel) x 1 = 23450 Riel')
          div('total').should have_content('Total: 48130 Riel')
        end
      end
    
      it "show order info" do
        visit validate_order_path(@order)
        div('total').should have_content('Total: 24680 Riel')
        div('name').should have_content('Name: New Name')
        div('address').should have_content('Address: New Address')
        div('email').should have_content('Email: new@email.com')
        div('pay_type').should have_content('Pay Type: Purchase Order')
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
    end
    context "confirm order" do
      before(:each) do
        visit validate_order_path(@order)
        form(:confirm_order).click_button 'Confirm'
      end
      
      it "status is changed to 'confirmed'" do
        Order.last.aasm_state.should eq 'confirmed'
      end

      it "redirect to the root page" do
        current_path.should eq root_path
      end
    end
  end
end
