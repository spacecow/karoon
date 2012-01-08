require 'spec_helper'

describe "Authors" do
  describe "show" do
    before(:each) do
      @way = create_book('This is the Way')
      @road = create_book('The Lonely Road')
      @author = create_author('Stephen King')
      @author.books << @way 
      @author.books << @road
    end 

    it "layout" do
      visit author_path(@author)
      page.should have_title('Stephen King') 
      page.should have_content('Book: This is the Way, The Lonely Road')
      page.should have_link('This is the Way')
      page.should have_link('The Lonely Road')
      bottom_links.should_not have_link('Edit')
      bottom_links.should_not have_link('Delete')
    end

    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit author_path(@author)
      bottom_links.should have_link('Edit')
      bottom_links.should have_link('Delete')
    end

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit author_path(@author)
      end
  
      it "edit author" do 
        bottom_links.click_link 'Edit'
        page.current_path.should eq edit_author_path(@author) 
      end
      it "delete author" do 
        lambda do
          bottom_links.click_link 'Delete'
        end.should change(Author,:count).by(-1)
        page.current_path.should eq authors_path
      end
    end

    context "general links to" do
      before(:each) do
        visit author_path(@author)
      end

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
