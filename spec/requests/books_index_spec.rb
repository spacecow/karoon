require 'spec_helper'

describe "Books" do
  describe "index" do
    before(:each) do
      @book = create_book("This is the Way")
    end

    context "layout" do
      it "general" do
        visit books_path
        page.should have_title('Books')
        div('book',0).should have_link("This is the Way")
        div('book',0).should_not have_link('Edit')
        div('book',0).should_not have_link('Del')
        page.should_not have_link('New Book')
      end

      it "admin" do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit books_path
        div('book',0).should have_link('Edit')
        div('book',0).should have_link('Del')
        page.should have_link('New Book')
      end
    end

    context "general links to" do
      it "This is the Way" do
        visit books_path 
        div('book',0).click_link "This is the Way"
        page.current_path.should eq book_path(@book)
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
