require 'spec_helper'

describe "Categories" do
  before(:each) do
    create_admin(:email=>'admin@example.com')
    login('admin@example.com')
    visit new_category_path
  end

  describe "new" do
    it "layout" do
      page.should have_title('New Category')
      find_field('Name').value.should be_nil
      options('Parent')
      page.should have_button('Create Category')
    end

    context "create a category" do
      before(:each) do
        fill_in 'Name', :with => 'science'
      end

      it "adds a category to the database" do
        lambda do
          click_button 'Create Category'
        end.should change(Category,:count).by(1)
        Category.last.name.should eq 'science'
      end

      it "name cannot be blank" do
        fill_in 'Name', :with => ''
        click_button 'Create Category'
        li(:name).should have_blank_error
      end

      it "name cannot be duplicated" do
        create_category('science')
        click_button 'Create Category'
        li(:name).should have_duplication_error
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
