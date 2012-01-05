require 'spec_helper'

describe "Categories" do
  describe "index" do
    before(:each) do
      @space = create_category('space')
      @science = create_category('science')
    end

    it "general layout" do
      visit categories_path
      page.should have_title('Categories') 
      row(0).should have_link('science')
      row(1).should have_link('space')
      table.should_not have_link('Edit')
      table.should_not have_link('Del')
      page.should_not have_link('New Category')
    end

    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit categories_path
      table.should have_link('Edit')
      table.should have_link('Del')
      page.should have_link('New Category')
    end

    context "general links to" do
      before(:each) do
        visit categories_path
      end

      it "science" do
        row(0).click_link 'science'
        page.current_path.should eq category_path(@science) 
      end
      it "space" do
        row(1).click_link 'space'
        page.current_path.should eq category_path(@space) 
      end
    end

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit categories_path
      end

      it "new category" do
        click_link 'New Category'
        page.current_path.should eq new_category_path
      end
      it "edit category" do
        row(0).click_link 'Edit'
        page.current_path.should eq edit_category_path(@science)
      end
      it "destroy category" do
        lambda do
          row(0).click_link 'Del'
        end.should change(Category,:count).by(-1)
        page.current_path.should eq categories_path
        page.should have_notice("Category: 'science' was successfully deleted.")
      end
    end
  end
end
