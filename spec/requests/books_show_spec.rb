require 'spec_helper'

describe "Books" do
  describe "show" do
    before(:each) do
      @book = Factory(:book,:title=>'This is the Way',:regular_price=>1000)
    end 

    context "general layout" do
      it "has the book title as page title" do
        visit book_path(@book)
        div('book').should have_title('This is the Way') 
      end

      context "users dont see links" do
        it "edit" do
          visit book_path(@book)
          bottom_links.should_not have_link('Edit')
        end
        it "delete" do
          visit book_path(@book)
          bottom_links.should_not have_link('Delete')
        end
      end

      context "form" do
        before(:each){ visit book_path(@book) }
        it "exists for adding line items" do
          page.should have_form('new_line_item') 
        end
        it "has a 'Add to Cart' button" do
          form('new_line_item').should have_button('Add to Cart')
        end
        context "has a quantity selection" do
          it "with a range from 1 to 10" do
            form('new_line_item').div('quantity').options(:quantity).should eq "1, 2, 3, 4, 5, 6, 7, 8, 9, 10" 
          end
          it "with no 1 selected" do
            form('new_line_item').div('quantity').selected_value(:quantity).should eq "1"
          end
        end
      end

      context "summary layout" do
        it "no div if no summary" do
          visit book_path(@book)
          div('book').should_not have_div('summary')
        end
        it "show summary in div if it exists" do
          @book.update_attribute(:summary,"Not a very long summary.")
          visit book_path(@book)
          div(:book).div(:summary).should have_content("\"Not a very long summary.\"")
        end
      end

      context "image" do
        it "default if no image exists" do
          visit book_path(@book)
          div('book').should have_image('Books-pile')
        end
        it "show attached image if it exists" do
          @book.update_attribute(:image,File.open(File.join(Rails.root, 'app', 'assets', 'images', 'cover.jpg')))
          visit book_path(@book)
          div('book').should have_image('Main_cover')
        end
      end

      context "regular price layout" do
        it "in Toman" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          visit book_path(@book)
          div('book').should have_content('Price: 1000 Toman') 
        end
        it "in Riel" do
          Setting.singleton.update_attribute(:currency,Setting::RIEL)
          visit book_path(@book)
          div('book').should have_content('Price: 10000 Riel') 
        end
      end
    
      context "category layout" do
        before(:each) do
          @book.categories.destroy_all
        end

        it "none, if there are none" do
          visit book_path(@book)
          div('book').should have_content('Categories: -')
        end

        context "for" do
          before(:each) do
            @book.categories.destroy_all
            @science = create_category('science')
            rocket = create_category('rocket',@science.id)
            @book.categories << rocket 
          end
          it "one" do
            visit book_path(@book)
            div('book').should have_content('Category: science/rocket')
            div('book').should have_link('science/rocket')
          end
          it "two, listed in order" do
            @book.categories << @science 
            visit book_path(@book)
            div('book').should have_content('Categories: science, science/rocket')
            div('book').should have_link('science')
            div('book').should have_link('science/rocket')
          end
        end
      end

      context "author layout" do
        it "none, if there are none" do
          visit book_path(@book)
          div('book').should have_content('Authors: -')
        end
        context "for" do
          before(:each) do
            @book.authors << create_author('King')
          end
          it "one" do
            visit book_path(@book)
            div('book').should have_content('Author: King')
            div('book').should have_link('King')
          end
          it "two" do
            @book.authors << create_author('Koontz')
            visit book_path(@book)
            div('book').should have_content('Authors: King, Koontz')
            div('book').should have_link('King')
            div('book').should have_link('Koontz')
          end
        end
      end
    end


    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit book_path(@book)
      bottom_links.should have_link('Edit')
      bottom_links.should have_link('Delete')
    end

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit book_path(@book)
      end
  
      it "edit book" do 
        bottom_links.click_link 'Edit'
        page.current_path.should eq edit_book_path(@book) 
      end
      it "delete book" do 
        lambda do
          bottom_links.click_link 'Delete'
        end.should change(Book,:count).by(-1)
        page.current_path.should eq books_path
      end
    end

    context "general links to" do
      before(:each) do
        @king = create_author('Stephen King')
        @koontz = create_author('Dean R. Koontz')
        @science = create_category('science')
        @book.authors << @king
        @book.authors << @koontz
        @book.categories << @science
        visit book_path(@book)
      end

      it "Stephen King" do
        div('book').click_link('Stephen King')
        page.current_path.should eq author_path(@king)
      end
      it "Dean R. Koontz" do
        div('book').click_link 'Dean R. Koontz'
        page.current_path.should eq author_path(@koontz)
      end
      it "science" do
        div('book').click_link 'science'
        page.current_path.should eq category_path(@science)
      end
      context "new order page" do

        it "redirects to the cart" do
          form('new_line_item').click_button('Add to Cart')
          page.current_path.should eq cart_path(Cart.last)
        end
        context "adds a line item" do
          it "to the database" do
            lambda do
              form('new_line_item').click_button('Add to Cart')
            end.should change(LineItem,:count).by(1)
          end 
          it "to the cart" do
            form('new_line_item').click_button('Add to Cart')
            Cart.last.line_items.should eq [LineItem.last] 
          end
        end
        context "shows a flash message adding" do
          it "a book" do
            form('new_line_item').click_button('Add to Cart')
            page.should have_notice("Book: 'This is the Way' was added to your cart.")
          end
          it "three books" do
            form('new_line_item').select "3", :from => :quantity
            form('new_line_item').click_button('Add to Cart')
            page.should have_notice("3 Books: 'This is the Way' were added to your cart.")
          end
        end
      end
    end
  end
end
