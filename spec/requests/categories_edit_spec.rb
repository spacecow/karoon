require 'spec_helper'

describe "Categories" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      @science = create_category('science')
      create_category('rocket',@science.id)
      visit edit_category_path(@science)
    end

    it "layout" do
      page.should have_title('Edit Category')
      find_field('Name').value.should eq "science"
      options('Parent').should eq "BLANK, science, rocket"
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
        Category.first.name.should eq 'space'
      end

      it "descendants names_depth_cache is updated" do
        click_button 'Update Category'
        Category.last.names_depth_cache.should eq 'space/rocket'
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
      it "parent cannot be set to oneself" do
        select 'science', :from => 'Parent'
        click_button 'Update Category'
      end

      it "shows a flash message" do
        click_button 'Update Category'
        page.should have_notice "Category: 'space' was successfully updated."
      end

      it "gets redirected to that category page" do
        click_button 'Update Category'
        page.current_path.should eq category_path(@science)
      end
    end
  end
end
