require 'spec_helper'

describe "Orders" do
  describe "new" do
    it "email check"

    before(:each) do
      @member = create_member(:email=>'member@example.com')
      login('member@example.com')
      @cart = Cart.last
      @book = Factory(:book,:title=>'Funny Title',:regular_price=>"1234")
      @item = @cart.line_items.create!(:book_id=>@book.id)
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

      context "list line items" do
        it "one" do
          @book.update_attribute(:image,File.open(File.join(Rails.root, 'app', 'assets', 'images', 'cover.jpg')))
          visit new_order_path
          div(:line_item,0).div(:image).should have_image('Mini_cover')
          div(:line_item,0).div(:info).should have_content('Funny Title')
          div(:line_item,0).div(:price).should have_content('1234 Toman x 1 = 1234 Toman')
          div(:line_items).div(:total).should have_content('Total: 1234 Toman')
        end
        it "two" do
          book2 = Factory(:book,:title=>'Funnier Title',:regular_price=>"2345")
          @cart.line_items.create!(:book_id=>book2.id,:quantity=>2)
          visit new_order_path
          div(:line_item,1).div(:image).should have_image('Books-pile-mini')
          div(:line_item,1).div(:info).should have_content('Funnier Title')
          div(:line_item,1).div(:price).should have_content('2345 Toman x 2 = 4690 Toman')
          div(:line_items).div(:total).should have_content('Total: 5924 Toman')
        end
      end

      context "no previous order exists" do
        it "default: no order is filled in" do
          visit new_order_path
          find_field('Name').value.should be_nil
          find_field('Address').value.should be_empty
          find_field('Email').value.should be_nil
          options('Pay Type').should eq 'Pay on Delivery'
          selected_value('Pay Type').should eq 'Pay on Delivery' 
          options('Postal Service').should eq 'BLANK, Camel Caravan, Flying Carpet, Scud Missile'
          selected_value('Postal Service').should be_empty
        end
      end

      context "a previous order exists" do
        it "new order is filled in" do
          Factory(:order,:user_id=>@member.id,:name=>'Last Name',:address=>'Last Address',:email=>'Last Email',:pay_type=>'Pay on Delivery',:postal_service=>'Scud Missile')
          visit new_order_path
          find_field('Name').value.should eq 'Last Name'
          find_field('Address').value.should eq 'Last Address'
          find_field('Email').value.should eq 'Last Email'
          selected_value('Pay Type').should eq 'Pay on Delivery'
          selected_value('Postal Service').should eq 'Scud Missile'
        end
      end
    end

    context "create order" do
      before(:each) do
        visit new_order_path
        fill_in 'Name', :with => "New Name"
        fill_in 'Address', :with => "New Address"
        fill_in 'Email', :with => "new@email.com"
        select 'Pay on Delivery', :from => 'Pay Type' 
        select 'Flying Carpet', :from => 'Postal Service' 
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
        end.should change(Cart,:count).by(0) 
        Cart.last.should_not eq @cart
      end

      it "redirects to the create page" do
        click_button 'Create Order'
        current_path.should eq validate_order_path(Order.last)
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

        it "postal service must be present" do
          select '', :from => 'Postal Service'
          click_button 'Create Order'
          li(:postal_service).should have_inclusion_error 
        end
      end
    end
  end
end
