require 'spec_helper'

describe "Users, show:", focus:true do
  context "user layout without orders" do
    before(:each) do
      visit user_path(login_member)
    end

    it "a div for orders exists" do
      page.should have_div(:orders)
    end

    it "a div for all orders exist" do
      div(:orders).should have_div(:all)      
    end

    it "a div for draft orders exist" do
      div(:orders).should have_div(:drafts)      
    end

    it "a div for confirmed orders exist" do
      div(:orders).should have_div(:confirmed)      
    end
  end

  context "user page, links to" do
    before(:each){ visit user_path(login_member) }

    context "all orders" do
      before(:each) do
        div(:orders).div(:all).click_link 'All Orders'
      end

      it "title shows 'All Orders'" do
        page.should have_title('All Orders')
      end
    end
    
    context "draft orders" do
      before(:each) do
        div(:orders).div(:drafts).click_link 'Draft Orders'
      end

      it "title shows 'Draft Orders'" do
        page.should have_title('Draft Orders')
      end
    end

    context "confirmed orders" do
      before(:each) do
        div(:orders).div(:confirmed).click_link 'Confirmed Orders'
      end

      it "title shows 'Confirmed Orders'" do
        page.should have_title('Confirmed Orders')
      end
    end

    after(:each) do
      current_path.should eq orders_path
    end
  end
end
