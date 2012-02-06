require 'spec_helper'

describe "Categories" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit new_category_path
    end

    context "errors:" do
      it "name cannot be blank" do
        fill_in 'Name', :with => ''
        click_button 'Create Category'
        li(:name).should have_blank_error
      end

      it "name cannot be duplicated" do
        create_category('science')
        fill_in 'Name', :with => 'science'
        click_button 'Create Category'
        li(:name).should have_duplication_error
      end

      it "cannot include space" do
        fill_in 'Name', :with => 'a b'
        click_button 'Create Category'
        li(:name).should have_invalid_error
      end

      it "can include underbar" do
        lambda do
          fill_in 'Name', :with => 'a_b'
          click_button 'Create Category'
        end.should change(Category,:count).by(1)
      end
    end #errors:
  end #new
end
