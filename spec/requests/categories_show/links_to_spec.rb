require 'spec_helper'

describe "Categories" do
  describe "show" do
    before(:each) do
      @category = create_category('science')
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
      context "delete category" do 
        it "deletes a category from the database" do
          lambda do
            bottom_links.click_link 'Delete'
          end.should change(Category,:count).by(-1)
        end

        it "redirects to the category index page" do
          bottom_links.click_link 'Delete'
          page.current_path.should eq categories_path
        end
      end
    end

    context "general links to" do
      before(:each) do
        @way = create_book('This is the Way')
        @road = create_book('The Lonely Road')
        @category.books << @way 
        @category.books << @road
        visit category_path(@category)
      end

      it "book: This is the Way" do
        click_link('This is the Way')
        page.current_path.should eq book_path(@way)
      end
  
      it "book: The Lonely Road" do
        click_link 'The Lonely Road'
        page.current_path.should eq book_path(@road)
      end
    end
  end
end
