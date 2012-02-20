require 'spec_helper'

describe "Categories" do
  describe "index" do
    before(:each) do
      @space = create_category('space')
      @science = create_category('science')
    end


    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit categories_path
      end

      it "destroy parent category does not destory children" do
        rocket = create_category('rocket',@space.id)        
        fuel = create_category('fuel',rocket.id)
        div('category',1).click_link 'Del'
        Category.find(rocket.id).names_depth_cache_en.should eq 'rocket'
        Category.find(fuel.id).names_depth_cache_en.should eq 'rocket/fuel'
      end
    end
  end
end
