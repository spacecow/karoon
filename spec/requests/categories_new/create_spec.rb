require 'spec_helper'

describe "Categories" do
  describe "new" do

    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      create_category('ruby')
      visit new_category_path
    end

    context "create a category" do
      before(:each) do
        fill_in 'Name', :with => 'science'
        select 'ruby', :from => 'Parent'
      end

      it "adds a category to the database" do
        lambda do
          click_button 'Create Category'
        end.should change(Category,:count).by(1)
        Category.last.name.should eq 'science'
      end

      it "shows a flash message" do
        click_button 'Create Category'
        page.should have_notice("Category: 'science' was successfully created.")
      end

      it "redirects to the new category page" do
        click_button 'Create Category'
        page.current_path.should eq new_category_path
      end
    end
  end
end
