require 'spec_helper'

describe "Books" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit new_book_path
    end

    context "flash.now" do
      it "nothing filled in, created" do
        click_button 'Create Book'
        fill_in_book
        fill_in_book(1,:title=>"Partial")
        click_button 'Create Book' 
        page.should_not have_alert
      end
      it "created, nothing fill in" do
        fill_in_book
        fill_in_book(1,:title=>"Partial")
        click_button 'Create Book'
        fill_in_book(0,:title=>"")
        click_button 'Create Book' 
        page.should_not have_notice
      end
      it "created, nothing created" do
        fill_in_book
        fill_in_book(1,:title=>"Partial")
        click_button 'Create Book'
        click_button 'Create Book'
        page.should_not have_notice
      end
      it "nothing created, created" do
        fill_in_book(1,:title=>"Partial")
        click_button 'Create Book'
        fill_in_book
        fill_in_book(1,:title=>"Partial")
        click_button 'Create Book'
        page.should_not have_alert
      end
    end

    context "no book is created since" do
      context "nothing is filled in" do
        before(:each){ click_button 'Create Book' }

        it "displays an alert flash" do
          page.should have_alert('No Book was created.')
          page.should_not have_notice
        end

        it "renders the new book page" do
          page.current_path.should eq create_individual_books_path
        end

        it "shows all errors" do
          li(:title,0).should have_blank_error 
          li(:regular_price,0).should have_blank_error 
          li(:regular_price,0).should_not have_numericality_error 
          li(:category_tokens,0).should have_blank_error 
        end

        it "10 forms should be shown" do
          divs(:book).count.should be(10) 
        end
      end

      context "all required fields are not filled in" do
        before(:each) do
          fill_in_book(0,:title=>"Partial")
          click_button 'Create Book'
        end

        it "displays an alert flash" do
          page.should have_alert('No Book was created.')
          page.should_not have_notice
        end

        it "renders the new book page" do
          page.current_path.should eq create_individual_books_path
        end

        it "10 forms should be shown" do
          divs(:book).count.should be(10) 
        end
      end
    end


    context "1 book is created from" do
      context "new, by filling in only one book" do
        before(:each) do
          fill_in_book
          click_button 'Create Books'
        end

        it "redirects to the new book page" do
          page.current_path.should eq new_book_path
        end

        it "shows a flash notice message" do
          page.should have_notice("1 Book was successfully created.")
          page.should_not have_alert
        end
      end

      context "new, by filling in 1.5 book" do
        before(:each) do
          fill_in_book
          fill_in_book(1,:title=>"Partial")
          click_button 'Create Books'
        end

        it "renders the new book page" do
          page.current_path.should eq create_individual_books_path
        end

        it "shows a flash message" do
          page.should have_notice("1 Book was successfully created.")
          page.should_not have_alert
        end

        it "sees 10 book forms" do
          divs(:book).count.should be(10) 
        end
      end

      context "error, by filling in only one book" do
        before(:each) do
          click_button 'Create Books'
          fill_in_book
          click_button 'Create Books'
        end

        it "redirects to the new book page" do
          page.current_path.should eq new_book_path
        end

        it "shows a flash notice message" do
          page.should have_notice("1 Book was successfully created.")
          page.should_not have_alert
        end
      end

      context "error, by filling in 1.5 book" do
        before(:each) do
          click_button 'Create Books'
          fill_in_book
          fill_in_book(1,:title=>"Partial")
          click_button 'Create Books'
        end

        it "renders the new book page" do
          page.current_path.should eq create_individual_books_path
        end

        it "shows a flash message" do
          page.should have_notice("1 Book was successfully created.")
        end

        it "sees 10 book forms" do
          divs(:book).count.should be(10) 
        end
      end
    end

    context "2 books are created" do
      context "displays a flash message from" do
        before(:each) do
          fill_in_book(0,"A","1000","A")
          fill_in_book(1,"B","1000","B")
          click_button 'Create Book'
        end

        it "displays a plural flash message" do
          page.should have_notice("2 Books were successfully created")
        end
        it "redirects back" do
          page.current_path.should eq new_book_path
        end
      end
    end

    context "the first book is partially filled in" do
      before(:each) do
        fill_in_book(0,:title=>"Partially")
        click_button 'Create Books'
      end

      it "does not show a flash notice" do
        page.should_not have_notice
      end
    end

    context "a second book is partially filled in" do
      before(:each) do
        fill_in_book
      end

      context "redirects back for filled in" do
        it "title" do
          fill_in_book(1,:title => "C")
        end
        it "summary" do
          fill_in_book(1,:summary => "C")
        end
        it "regular_prize" do
          fill_in_book(1,:regular_price => "C")
        end
        it "image" do
          fill_in_book(1,:image => "spec/tree.png")
        end
        it "author" do
          fill_in_book(1,:author => "C")
        end
        it "category" do
          fill_in_book(1,:category => "C")
        end
        after(:each) do
          click_button 'Create Book'
          page.current_path.should eq create_individual_books_path
          divs(:book).count.should be(10) 
        end
      end
    end
  end
end
