require 'spec_helper'

describe "Categories" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      @science = create_category('science')
      @rocket = create_category('rocket',@science.id)
      religion = create_category('religion')
      @mantra = create_category('mantra',religion.id)
      visit edit_category_path(@science)
    end

    it "layout" do
      page.should have_title('Edit Category')
      find_field('Name').value.should eq "science"
      options('Parent').should eq "BLANK, religion, religion/mantra"
      page.should have_button('Update Category')
    end

    context "edit category" do
      before(:each) do
        fill_in 'Name', :with => "space" 
        select 'religion/mantra', :from => 'Parent'
      end

      it "new version is saved to database" do
        lambda do
          click_button 'Update Category'
        end.should change(Category,:count).by(0)
        Category.find(@science.id).name.should eq 'space'
        Category.find(@science.id).names_depth_cache_en.should eq 'religion/mantra/space'
        Category.find(@science.id).parent.should eq @mantra
      end

      it "descendants names_depth_cache is updated" do
        click_button 'Update Category'
        Category.find(@rocket.id).names_depth_cache_en.should eq 'religion/mantra/space/rocket'
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
      it "options should remain on error page" do
        fill_in 'Name', :with => ''
        click_button 'Update Category'
        options('Parent').should eq "BLANK, religion, religion/mantra"
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
