require 'spec_helper'

describe "Books" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit new_book_path
    end

    context "no book is created" do
      before(:each) do
        click_button 'Create Book'
      end

      it "displays an alert flash" do
        page.should have_alert('No Book was created.')
      end
      it "redirects back" do
        page.current_path.should eq create_individual_books_path
      end
      it "shows all errors" do
        li(:title).should have_blank_error 
        li(:regular_price).should have_blank_error 
        li(:regular_price).should_not have_numericality_error 
        li(:category).should have_blank_error 
      end
      it "10 forms should be shown" do
        divs(:book).count.should be(10) 
      end
    end

    context "1 book is created" do
      context "displays a flash message from" do
        it "new" do
          fill_in_book
          click_button 'Create Book'
        end
        it "create" do
          click_button 'Create Book'
          fill_in_book
          click_button 'Create Book'
        end
        after(:each) do
          page.should have_notice("1 Book was successfully created")
          page.current_path.should eq new_book_path
        end
      end
      it "10 forms should be shown" do
        divs(:book).count.should be(10) 
      end
    end

    context "2 books are created" do
      context "displays a flash message from" do
        it "new" do
          fill_in_book(0,"A","1000","A")
          fill_in_book(1,"B","1000","B")
          click_button 'Create Book'
          page.should have_notice("2 Book was successfully created")
          page.current_path.should eq new_book_path
        end
      end
      it "10 forms should be shown" do
        divs(:book).count.should be(10) 
      end
    end
    it "should have correct plural flash message"

    context "book is partially filled in" do
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
        end
      end
      it "10 forms should be shown" do
        divs(:book).count.should be(10) 
      end
    end
  end
end
