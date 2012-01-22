require 'spec_helper'

describe "Carts" do
  describe "show" do
    before(:each) do
      @cart = Factory(:cart)
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
          div('line_item',0).div('price').should have_content('20000 Toman')
        end
        it "for Riel" do
          Setting.singleton.update_attribute(:currency,Setting::RIEL)
          visit cart_path(@cart)
          div('line_item',0).div('price').should have_content('200000 Riel')
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
