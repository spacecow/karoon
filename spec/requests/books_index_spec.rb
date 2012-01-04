require 'spec_helper'

describe "Books" do
  describe "index" do
    context "layout" do
      it "general" do
        visit books_path
        page.should have_title('Books')
        page.should_not have_link('New Book')
      end

      it "admin" do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit books_path
        page.should have_link('New Book')
      end
    end

    context "link to" do
      it "new book" do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit books_path
        click_link('New Book') 
        page.current_path.should eq new_book_path
      end
    end
  end
end
