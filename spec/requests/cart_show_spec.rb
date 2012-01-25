require 'spec_helper'

describe "Carts" do
  describe "show" do
    before(:each) do
      visit root_path
      @cart = Cart.last 
    end

    context "attempt to display a cart that does not exists" do
      it "generates an alert message" do
        visit cart_path(1)
        page.should have_alert("Invalid cart.")
      end
      
      it "redirects to the book index" do
        visit cart_path(1)
        page.current_path.should eq books_path
      end
    end

    context "layout" do
      context "price is multiplied with quantity" do
        before(:each) do
          book = Factory(:book,:regular_price=>'10000')
          @cart.line_items.create!(:book_id=>book.id,:quantity=>2)
        end

        it "for Toman" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          visit cart_path(@cart)
          div(:line_item,0).div(:price).should have_content('Book Price: 10000 Toman')
          div(:line_item,0).div(:book_total).should have_content('Total: 20000 Toman')
        end
        it "for Riel" do
          Setting.singleton.update_attribute(:currency,Setting::RIEL)
          visit cart_path(@cart)
          div(:line_item,0).div(:price).should have_content('Book Price: 100000 Riel')
          div(:line_item,0).div(:book_total).should have_content('Total: 200000 Riel')
        end
      end

      context "total price in" do
        before(:each) do
          book = Factory(:book,:regular_price=>'10000')
          @cart.line_items.create!(:book_id=>book.id,:quantity=>2)
          book2 = Factory(:book,:regular_price=>'30000')
          @cart.line_items.create!(:book_id=>book2.id)
        end

        it "Toman" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          visit cart_path(@cart)
          div('total').should have_content('Total: 50000 Toman')
        end
        it "Riel" do
          Setting.singleton.update_attribute(:currency,Setting::RIEL)
          visit cart_path(@cart)
          div('total').should have_content('Total: 500000 Riel')
        end
      end
    end

    context "checkout button" do
      it "exists with no items in the cart" do
        visit cart_path(@cart)
        page.should have_button('Checkout')
      end
      it "exists with items in the cart" do
        book = Factory(:book)
        @cart.line_items.create!(:book_id=>book.id)
        visit cart_path(@cart)
        page.should have_button('Checkout')
      end
    end

    context "layout" do
      before(:each) do
        visit cart_path(@cart)
      end

      it "title is set to 'Your Cart'" do
        page.should have_title('Your Cart')
      end

      it "should have an empty cart button" do
        page.should have_button('Empty Cart')
      end

      it "should have an update cart button" do
        page.should have_button('Update Cart')
      end
    end

    context "layout" do
      it "the price of an added book cannot be affected afterhand" do
        @book = Factory(:book)
        @cart.line_items.create!(:book_id=>@book.id,:regular_price=>'1000')
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit edit_book_path(@book)
        fill_in 'Regular Price', :with => 2000
        fill_in 'Category', :with => 'science'
        click_button 'Update Book'
        visit cart_path(@cart)
        div('line_item',0).div('price').should have_content('Book Price: 1000')
      end

      context "quantity" do
        before(:each){ @book = Factory(:book) }
        it "1" do
          @cart.line_items.create!(:book_id=>@book.id)
          visit cart_path(@cart)
          div('line_item',0).selected_value('Quantity').should eq '1'
        end
        it "2" do
          @cart.line_items.create!(:book_id=>@book.id,:quantity=>2)
          visit cart_path(@cart)
          div('line_item',0).selected_value('Quantity').should eq '2'
        end
      end

      context "list cart content" do
        before(:each) do
          book = Factory(:book)
          @cart.line_items.create!(:book_id=>book.id)
          visit cart_path(@cart)
        end

        it "book should be listed" do
          page.should have_div('line_item',0)
        end

        it "should have no 'Add to Cart' button" do
          page.should_not have_button('Add to Cart')
        end

        it "should have no actions" do
          page.should_not have_div('actions')
        end
      end
    end

    context "update quantity of line item" do
      before(:each) do
        book = Factory(:book)
        @cart.line_items.create!(:book_id=>book.id)
        visit cart_path(@cart)
        div('line_item',0).select '5', :from => 'Quantity'
      end

      it "no new cart or line items are created" do
        lambda do
          lambda do
            click_button 'Update Cart'
          end.should change(LineItem,:count).by(0)
        end.should change(Cart,:count).by(0)
      end 

      it "is updated in the database" do
        click_button 'Update Cart'
        LineItem.last.quantity.should be(5)
      end 

      it "redirects to the cart" do
        click_button 'Update Cart'
        current_path.should eq cart_path(@cart)
      end

      it "shows a flash message" do
        click_button 'Update Cart'
        page.should have_notice('Cart was successfully updated.')
      end
    end

    context "checkout" do
      it "redirects to the login page if not logged in" do
        visit cart_path(@cart)
        click_button 'Checkout'
        current_path.should eq login_path
      end

      context "redirects to the new order page" do
        before(:each) do
          create_member(:email=>'member@example.com')
          book = Factory(:book)
          @cart.line_items.create!(:book_id=>book.id)
        end

        it "after logging in and items are in the cart" do
          visit cart_path(@cart)
          click_button 'Checkout'
          login('member@example.com')
        end

        it "if logged in and items are in the cart" do
          login('member@example.com')
          visit cart_path(@cart)
          click_button 'Checkout'
        end
        
        after(:each) do
          current_path.should eq new_order_path
        end
      end

      context "redirects to the root page" do
        it "if logged in and no items in the cart" do
          create_member(:email=>'member@example.com')
          login('member@example.com')
          visit cart_path(@cart)
          click_button 'Checkout'
          current_path.should eq root_path 
          page.should have_notice('Your cart is empty.')
        end
        it "if not logged and no items in the cart"

        it "shows a flash message about no items in the cart"
      end
    end

    context "empty cart" do
      before(:each) do
        visit cart_path(@cart)
      end
      
      it "deletes the cart" do
        cart = Cart.last
        click_button 'Empty Cart'
        cart.should_not eq Cart.last
      end
      it "deletes all line_items" do
        book = Factory(:book)
        @cart.line_items.create!(:book_id=>book.id)
        lambda do
          click_button 'Empty Cart'
        end.should change(LineItem,:count).by(-1)
      end
      it "redirects to the root page" do
        click_button 'Empty Cart'
        current_path.should eq root_path
      end
      it "shows a flash message" do
        click_button 'Empty Cart'
        page.should have_notice('Your cart is currently empty.')
      end
      it "cart can only be emptied by the user who created it"
    end
  end
end
