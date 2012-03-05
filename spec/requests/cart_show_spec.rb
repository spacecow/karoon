require 'spec_helper'

describe "Carts" do
  describe "show" do
    before(:each) do
      visit root_path
      @cart = Cart.last 
    end

    it "ajax update when removing an item from a cart"

    it "no dropdown menu for no of items in the cart"

    context "attempt to display a cart that does not exist" do
      it "generates an alert message" do
        visit cart_path(1)
        page.should have_alert("Invalid cart.")
      end
      
      it "redirects to the book index" do
        visit cart_path(1)
        page.current_path.should eq welcome_path
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
        it "for Rial" do
          Setting.singleton.update_attribute(:currency,Setting::RIAL)
          visit cart_path(@cart)
          div(:line_item,0).div(:price).should have_content('Book Price: 100000 Rial')
          div(:line_item,0).div(:book_total).should have_content('Total: 200000 Rial')
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
        it "Rial" do
          Setting.singleton.update_attribute(:currency,Setting::RIAL)
          visit cart_path(@cart)
          div('total').should have_content('Total: 500000 Rial')
        end
      end
    end

    context "checkout button" do
      it "does not exist with no items in the cart" do
        visit cart_path(@cart)
        page.should_not have_button('Checkout')
      end
      it "exists with items in the cart" do
        book = Factory(:book)
        @cart.line_items.create!(:book_id=>book.id)
        visit cart_path(@cart)
        page.should have_button('Checkout')
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

        it "should have actions" do
          page.should have_div('actions')
        end

        it "should have a remove action" do
          div('actions').should have_link('Remove')
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
      #context "no items in the cart" do 
      #  context "logged in" do
      #    before(:each) do
      #      create_member(:email=>'member@example.com')
      #      login('member@example.com')
      #      visit cart_path(@cart)
      #      click_button 'Checkout'
      #    end

      #    it "redirects to the root path" do
      #      current_path.should eq root_path 
      #    end

      #    it "shows notice saying the cart is emtpy" do
      #      page.should have_notice('Your cart is empty.')
      #    end
      #  end

      #  context "not logged in" do
      #    before(:each) do
      #      visit cart_path(@cart)
      #      click_button 'Checkout'
      #    end

      #    it "redirects to the login path" do
      #      current_path.should eq login_path 
      #    end

      #    it "shows notice saying the cart is emtpy" do
      #      page.should have_alert('You must be logged in to place an order.')
      #    end
      #  end
      #end

      context "items in the cart" do
        before(:each) do
          b = Factory(:book)
          @cart.line_items.create!(:book_id=>b.id)
          create_member(:email=>'member@example.com')
        end

        context "not logged in" do
          before(:each) do
            visit cart_path(@cart)
            click_button 'Checkout'
          end

          it "redirects to the login page" do
            current_path.should eq login_path
          end
          it "shows notice telling to log in in order to place an order" do
            page.should have_alert('You must be logged in to place an order.')
          end
          context "redirects to the new order path after" do
            before(:each) do
              visit cart_path(@cart)
              click_button 'Checkout'
            end

            it "logging in" do
              login('member@example.com')
            end

            after(:each) do
              current_path.should eq new_order_path
            end
          end
        end
        context "logged in" do
          before(:each) do
            login('member@example.com')
          end

          it "redirects to the new_order_path" do
            visit cart_path(@cart)
            click_button 'Checkout'
            current_path.should eq new_order_path
          end
        end
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
        current_path.should eq cart_path(Cart.last) 
      end
      it "shows a flash message" do
        click_button 'Empty Cart'
        page.should have_notice('Your cart was emptied.')
      end
    end

    context "delete item from cart" do
      before(:each) do
        @book = Factory(:book,:title=>'Moby Dick')
        @line_item = @cart.line_items.create!(:book_id=>@book.id)
      end

      it "removes a line item from the database" do
        visit cart_path(@cart)
        lambda do
          div('line_item',0).click_link('Remove')      
        end.should change(LineItem,:count).by(-1)
      end

      it "removes the line item from the cart" do
        visit cart_path(@cart)
        div('line_item',0).click_link('Remove')      
        Cart.last.line_items.count.should be(0)
      end

      it "redirects back to the cart page" do
        visit cart_path(@cart)
        div('line_item',0).click_link('Remove')      
        current_path.should eq cart_path(@cart)
      end

      context "shows a flash message for quantity:" do
        it "singular" do
          visit cart_path(@cart)
          div('line_item',0).click_link('Remove')      
          page.should have_notice("Book: 'Moby Dick' was removed from your cart.") 
        end
        it "plural" do
          @line_item.update_attribute(:quantity,2)
          visit cart_path(@cart)
          div('line_item',0).click_link('Remove')      
          page.should have_notice("2 Books: 'Moby Dick' were removed from your cart.") 
        end
      end
    end
  end
end
