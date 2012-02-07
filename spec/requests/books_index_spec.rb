require 'spec_helper'

describe "Books" do
  describe "index" do
    before(:each) do
      @book = Factory(:book,:title=>"This is the Way",:regular_price=>1000,:summary=>"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
      @king = create_author('Stephen King')
      @book.authors << @king
      @book.categories.destroy_all
      @religion = create_category('religion')
      @book.categories << @religion 
    end

    context "layout" do
      it "general" do
        visit books_path
        div('book',0).should have_content("This is the Way by Stephen King")
        div('book',0).should have_link("This is the Way")
        div('book',0).should have_link("Stephen King")
        div('books').should_not have_link('Edit')
        div('books').should_not have_link('Del')
        div('book',0).should have_button('Add to Cart')
        div('book',0).options('Quantity').should eq "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
      end

      context "image" do
        it "none" do 
          visit books_path
          div('book',0).should have_image('Books-pile')
          div('book',0).should have_link('Books-pile')
        end
        it "exists" do
          @book.update_attribute(:image,File.open(File.join(Rails.root, 'app', 'assets', 'images', 'cover.jpg')))
          visit books_path
          div('book',0).should have_image('Thumb_cover')
          div('book',0).should have_link('Thumb_cover')
        end
      end

      context "summary" do
        context "none" do
          it "nil does not show listed" do
            @book.update_attribute(:summary,nil)
            visit books_path
          end
          it "empty does not show listed" do
            @book.update_attribute(:summary,"")
            visit books_path
          end
          it "exists, still does not show listed" do
            visit books_path
          end
          after(:each) do
            div('book',0).should_not have_div("summary")
          end
        end
      end

      context "category" do
        it "single" do
          visit books_path 
          div('book',0).should have_content('Category: religion') 
          div('book',0).should have_link("religion")
        end
        it "double" do
          @book.categories << create_category('science')
          visit books_path 
          div('book',0).should have_content('Categories: religion, science') 
          div('book',0).should have_link("religion")
          div('book',0).should have_link("science")
        end
      end
      context "price in" do
        it "Toman" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          visit books_path
          div('book',0).should have_content('Price: 1000 Toman')
        end
        it "Riel" do
          Setting.singleton.update_attribute(:currency,Setting::RIEL)
          visit books_path
          div('book',0).should have_content('Price: 10000 Riel')
        end
      end

      it "admin" do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit books_path
        div('books').should have_link('Edit')
        div('books').should have_link('Del')
        top_links.should have_link('New Book')
        bottom_links.should have_link('New Book')
      end
    end

    it "pagination on book index page"

    context "general links to" do
      context "This is the Way" do
        it "by clicking the title" do
          visit books_path 
          div('book',0).click_link "This is the Way"
        end
        it "by clicking the default image" do
          visit books_path 
          div('book',0).click_link "Books-pile"
        end
        it "by clicking the saved image" do
          @book.update_attribute(:image,File.open(File.join(Rails.root, 'app', 'assets', 'images', 'cover.jpg')))
          visit books_path 
          div('book',0).click_link "Thumb_cover"
        end

        after(:each) do
          page.current_path.should eq book_path(@book)
        end
      end
      it "Stephen King" do
        visit books_path
        div('book',0).click_link "Stephen King"
        page.current_path.should eq author_path(@king)
      end
      it "religion" do
        visit books_path
        div('book',0).click_link "religion"
        page.current_path.should eq category_path(@religion)
      end
      context "add book to cart" do
        before(:each) do
          visit books_path
          div('book',0).click_button 'Add to Cart'
        end
        it "redirects to the cart" do
          page.current_path.should eq cart_path(Cart.last) 
        end
        it "shows a flash message adding a book" do
          page.should have_notice("Book: 'This is the Way' was added to your cart.")
        end
      end
    end

    context "member links to" do
      before(:each) do
        @member = create_member(:email=>'member@example.com')
        login('member@example.com')
        visit books_path
      end

      it "flash message quantity if it is larger than 1" do
        div('book',0).select '2', :from => 'Quantity'
        div('book',0).click_button 'Add to Cart'
        page.should have_notice("2 Books: 'This is the Way' were added to your cart.")
      end

      context "add the same book to existing cart" do
        before(:each) do
          div('book',0).select '2', :from => 'Quantity'
          div('book',0).click_button 'Add to Cart'
          visit books_path 
        end

        it "does not create a new cart" do
          lambda do
            div('book',0).click_button 'Add to Cart'
          end.should change(Cart,:count).by(0)
        end

        it "does not create a new line item" do
          lambda do
            div('book',0).click_button 'Add to Cart'
          end.should change(LineItem,:count).by(0)
        end

        it "increases the quantity by 2" do
          div('book',0).click_button 'Add to Cart'
          LineItem.last.quantity.should be(3)
        end

      end

      context "add book to empty cart" do
        it "a cart should already've been created" do
          lambda do
            div('book',0).click_button 'Add to Cart'
          end.should change(Cart,:count).by(0)
        end
          
        it "creates a line item" do
          lambda do
            div('book',0).click_button 'Add to Cart'
          end.should change(LineItem,:count).by(1)
        end

        it "creates an associations from line item to cart, book and user" do
          div('book',0).click_button 'Add to Cart'
          line_item = LineItem.last
          line_item.cart.should eq Cart.last
          line_item.book.should eq @book
        end

        it "sets the default quantity to 1" do
          div('book',0).click_button 'Add to Cart'
          LineItem.last.quantity.should be(1)
        end

        it "quantity can be set" do
          div('book',0).select '5', :from => 'Quantity'
          div('book',0).click_button 'Add to Cart'
          LineItem.last.quantity.should be(5)
        end

        it "redirects to the cart" do
          div('book',0).click_button 'Add to Cart'
          page.current_path.should eq cart_path(Cart.last)
        end

        it "shows a flash message saying the book in question has been added to the cart" do
          div('book',0).click_button 'Add to Cart'
          page.should have_notice("Book: 'This is the Way' was added to your cart.")
        end
      end
    end

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit books_path
      end

      it "new book" do
        click_link 'New Book' 
        page.current_path.should eq new_book_path
      end

      it "edit book" do
        click_link 'Edit' 
        page.current_path.should eq edit_book_path(@book)
      end

      it "delete book" do
        lambda do
          click_link 'Del'
        end.should change(Book,:count).by(-1)
        page.current_path.should eq books_path
        page.should have_notice("Book: 'This is the Way' was successfully deleted.")
      end
    end
  end
end
