require 'spec_helper'

describe "Categories" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
    end

    context "layout:" do
      context "basic" do
        before(:each){ visit new_category_path }

        it "should have a title" do
          page.should have_title('New Category')
        end

        it "gives a hint of how to create the name"

        it "the name field should be empty" do
          find_field('Name').value.should be_nil
        end

        it "the parent field should have no selections" do
          options('Parent').should eq "BLANK"
        end
        it "the parent field should have no selections on the error page" do
          click_button 'Create Category'
          options('Parent').should eq "BLANK"
        end

        it "should have a create button" do
          page.should have_button('Create Category')
        end
      end #basic

      context "with predefined category" do
        before(:each) do
          create_category('ruby')
          visit new_category_path
        end

        it "the parent field should have selections" do
          options('Parent').should eq "BLANK, ruby"
        end

        it "the parent field should have selections on the error page" do
          click_button 'Create Category'
          options('Parent').should eq "BLANK, ruby"
        end
      end
    end #layout
  end
end
