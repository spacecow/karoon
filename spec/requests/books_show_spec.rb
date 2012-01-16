require 'spec_helper'

describe "Books" do
  describe "show" do
    before(:each) do
      @book = Factory(:book,:title=>'This is the Way',:regular_price=>1000)
    end 

    it "general layout" do
      visit book_path(@book)
      div('book').should have_title('This is the Way') 
      bottom_links.should_not have_link('Edit')
      bottom_links.should_not have_link('Delete')
    end

    context "summary layout" do
      it "none" do
        visit book_path(@book)
        div('book').should_not have_div('summary')
      end
      it "exists" do
        @book.update_attribute(:summary,"Not a very long summary.")
        visit book_path(@book)
        div('book').should have_content("\"Not a very long summary.\"")
      end
    end

    context "image" do
      it "none" do
        visit book_path(@book)
        div('book').should have_image('Books-pile')
      end
      it "attached image" do
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
      it "none" do
        @book.categories.destroy_all
        visit book_path(@book)
        div('book').should have_content('Category: -')
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
      it "none" do
        visit book_path(@book)
        div('book').should have_content('Author: -')
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
    end
  end
end
