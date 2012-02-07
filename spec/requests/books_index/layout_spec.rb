require 'spec_helper'

describe "Books" do
  describe "index" do
    context "member layout, no books" do
      before(:each){ visit books_path }

      it "has a title" do
        page.should have_title('Books')
      end

      it "has no new book link on the top of the page" do
        top_links.should_not have_link('New Book')
      end

      it "has no new book link on the bottom of the page" do
        bottom_links.should_not have_link('New Book')
      end
    end #member layout, no books

    context "member layout, book listing" do
      before(:each) do
        @book = create_book 
        @book.categories.destroy_all
      end

      it "no categories" do
        visit books_path
        div('book',0).div('categories').should have_content('Categories: -')
      end

      it "one category" do
        @book.categories << create_category('rocket_launcher')
        visit books_path
        div('book',0).div('categories').should have_content('Category: rocket launcher')
      end

      it "two root categories" do
        @book.categories << create_category('science')
        @book.categories << create_category('religion')
        visit books_path
        div('book',0).div('categories').should have_content('Categories: science, religion')
      end

      it "one root category and one leaf category" do
        @book.categories << create_category('science')
        religion = create_category('religion')
        @book.categories << create_category('islam',religion.id)
        visit books_path
        div('book',0).div('categories').should have_content('Categories: science, religion/islam')
      end
    end
  end
end
