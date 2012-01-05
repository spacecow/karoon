require 'spec_helper'

describe "Authors" do
  describe "show" do
    before(:each) do
      @way = create_book('This is the Way')
      @road = create_book('The Lonely Road')
      author = create_author('Stephen King')
      author.books << @way 
      author.books << @road
      visit author_path(author)
    end 

    it "layout" do
      page.should have_title('Stephen King') 
      page.should have_content('Book: This is the Way, The Lonely Road')
      page.should have_link('This is the Way')
      page.should have_link('The Lonely Road')
    end

    context "links to" do
      it "This is the Way" do
        click_link('This is the Way')
        page.current_path.should eq book_path(@way)
      end
  
      it "The Lonely Road" do
        click_link 'The Lonely Road'
        page.current_path.should eq book_path(@road)
      end
    end
  end
end
