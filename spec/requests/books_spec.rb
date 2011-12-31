require 'spec_helper'

describe "Books" do
  describe "index" do
    it "layout" do
      visit books_path
      page.should have_title('Books')
      page.should have_link('New Book')
    end

    context "link to" do
      it "new book" do
        visit books_path
        click_link('New Book') 
        #page.current_path.should eq new_book_path
      end
    end
  end
end
