require 'spec_helper'

describe "Books" do
  describe "show" do
    before(:each) do
      book = create_book('This is the Way')
      @king = create_author('Stephen King')
      @koontz = create_author('Dean R. Koontz')
      book.authors << @king
      book.authors << @koontz
      visit book_path(book)
    end 

    it "layout" do
      page.should have_title('This is the Way') 
      page.should have_content('Author: Stephen King, Dean R. Koontz')
      page.should have_link('Stephen King')
      page.should have_link('Dean R. Koontz')
    end

    context "links to" do
      it "Stephen King" do
        click_link('Stephen King')
        page.current_path.should eq author_path(@king)
      end
  
      it "Dean R. Koontz" do
        click_link 'Dean R. Koontz'
        page.current_path.should eq author_path(@koontz)
      end
    end
  end
end
