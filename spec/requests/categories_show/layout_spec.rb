require 'spec_helper'

describe "Categories" do
  describe "show" do
    before(:each) do
      @category = create_category('rocket launcher')
    end 

    context "member layout" do
      before(:each){ visit category_path(@category) }
      it "page has a translated title" do
        page.should have_title('rocket launcher') 
      end

      it "has no edit link" do
        bottom_links.should_not have_link('Edit')
      end

      it "has no delete link" do
        bottom_links.should_not have_link('Delete')
      end
    end

    context "admin layout" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit category_path(@category)
      end
      
      it "has an edit link" do
        bottom_links.should have_link('Edit')
      end

      it "has a delete link" do
        bottom_links.should have_link('Delete')
      end
    end
  end
end
