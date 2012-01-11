require 'spec_helper'

describe "Sessions" do
  describe "root" do
    it "general layout" do
      visit root_path
      site_nav.should have_link('Books')
      site_nav.should have_link('Authors')
      site_nav.should have_link('Categories')
      user_nav.should_not have_link('Settings')
    end

    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit root_path
      user_nav.should have_link('Settings')
    end
  
    it "admin should be able to change from real to tomen"

    context "admin links to" do
      it "settings" do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit root_path
        user_nav.click_link 'Settings'
        page.current_path.should eq edit_setting_path(Setting.singleton)
      end
    end

    context "general links to" do
      before(:each) do
        visit root_path
      end

      it "books" do
        site_nav.click_link('Books')
        page.current_path.should eq books_path
      end
      it "authors" do
        site_nav.click_link('Authors')
        page.current_path.should eq authors_path
      end
      it "categories" do
        site_nav.click_link('Categories')
        page.current_path.should eq categories_path
      end
    end
  end
end
