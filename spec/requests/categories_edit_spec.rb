require 'spec_helper'

describe "Categories" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      @category = create_category('science')
      visit edit_category_path(@category)
    end

    it "layout" do
      page.should have_title('Edit Category')
      find_field('Name').value.should eq "science"
      page.should have_button('Update Category')
    end

    context "edit category" do
      before(:each) do
        fill_in 'Name', :with => "space" 
      end

      it "new version is saved to database" do
        lambda do
          click_button 'Update Category'
        end.should change(Category,:count).by(0)
        Category.last.name.should eq 'space'
      end

      it "name cannot be blank" do
        fill_in 'Name', :with => ''
        click_button 'Update Category'
        li(:name).should have_blank_error
      end
      it "name must be unique" do
        create_category('space')
        click_button 'Update Category'
        li(:name).should have_duplication_error
      end

      it "shows a flash message" do
        click_button 'Update Category'
        page.should have_notice "Category: 'space' was successfully updated."
      end

      it "gets redirected to that category page" do
        click_button 'Update Category'
        page.current_path.should eq category_path(@category)
      end
    end
  end
end
