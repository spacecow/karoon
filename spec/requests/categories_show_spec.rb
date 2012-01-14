require 'spec_helper'

describe "Categories" do
  describe "show" do
    before(:each) do
      @way = create_book('This is the Way')
      @road = create_book('The Lonely Road')
      @category = create_category('science')
      @category.books << @way 
      @category.books << @road
    end 

    it "general layout" do
      visit category_path(@category)
      page.should have_title('science') 
      bottom_links.should_not have_link('Edit')
      bottom_links.should_not have_link('Delete')
    end

    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit category_path(@category)
      bottom_links.should have_link('Edit')
      bottom_links.should have_link('Delete')
    end

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit category_path(@category)
      end
  
      it "edit category" do 
        bottom_links.click_link 'Edit'
        page.current_path.should eq edit_category_path(@category) 
      end
      it "delete category" do 
        lambda do
          bottom_links.click_link 'Delete'
        end.should change(Category,:count).by(-1)
        page.current_path.should eq categories_path
      end
    end

    context "general links to" do
      before(:each) do
        visit category_path(@category)
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
