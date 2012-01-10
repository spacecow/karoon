require 'spec_helper'

describe "Books" do
  describe "show" do
    before(:each) do
      @book = create_book('This is the Way')
      @king = create_author('Stephen King')
      @koontz = create_author('Dean R. Koontz')
      @science = create_category('science')
      @book.authors << @king
      @book.authors << @koontz
      @book.categories.destroy_all
      @book.categories << @science
    end 

    it "layout" do
      visit book_path(@book)
      div('book').should have_title('This is the Way') 
      div('book').should have_content('Author: Stephen King, Dean R. Koontz')
      div('book').should have_link('Stephen King')
      div('book').should have_link('Dean R. Koontz')
      div('book').should have_content('Category: science')
      div('book').should have_link('science')
      bottom_links.should_not have_link('Edit')
      bottom_links.should_not have_link('Delete')
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
    end
  end
end
