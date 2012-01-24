require 'spec_helper'

describe "Orders", :focus=>true do
  describe "create" do
    before(:each) do
      Setting.singleton.update_attribute(:currency,Setting::RIEL)
      create_member(:email=>'member@example.com')
      login('member@example.com')
      cart = Cart.last
      book = Factory(:book,:title=>'Funny Title',:regular_price=>'1234')
      cart.line_items.create!(:book_id=>book.id,:quantity=>2)
      visit new_order_path
      fill_in 'Name', :with => "New Name"
      fill_in 'Address', :with => "New Address"
      fill_in 'Email', :with => "new@email.com"
      select 'Purchase Order', :from => 'Pay Type' 
      click_button 'Create Order'
    end

    context "layout" do
      it "should have a title" do
        page.should have_title('Confirm Order')
      end
      it "should have a cancel button"
      it "should have a confirm button"
    end

    context "list books" do
      it "one" do
        page.should have_content('Funny Title (12340 Riel) x 2 = 24680 Riel')
        div('total').should have_content('Total: 24680 Riel')
        div('name').should have_content('Name: New Name')
        div('address').should have_content('Address: New Address')
        div('email').should have_content('Email: new@email.com')
        div('pay_type').should have_content('Pay Type: Purchase Order')
      end
    end

    it "reload on the create page does not save the line items"
  end
end
