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

    context "edit category" do
      before(:each) do
        fill_in 'Name', :with => "space" 
        select 'religion/mantra', :from => 'Parent'
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
