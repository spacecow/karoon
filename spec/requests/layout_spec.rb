require 'spec_helper'

describe "Sessions" do
  describe "root" do
    before(:each) do
      visit root_path
    end

    it "layout" do
      site_nav.should have_link('Books')
      site_nav.should have_link('Authors')
      site_nav.should have_link('Categories')
    end

    context "links to" do
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
