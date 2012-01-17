require 'spec_helper'

describe "search_bar", :focus => true do
  context "layout" do
    it "search button" do
      visit root_path
      search_bar.find_button('Go')
    end

    context "keywords" do
      it "blank field" do
        visit root_path
        search_bar.find_field('Search').value.should eq nil
      end
    end

    context "category option:" do
      it "none" do
        visit root_path
        options("search_category_id",search_bar).should eq "Books"
      end
      it "one" do
        create_category('science')
        visit root_path
        options("search_category_id",search_bar).should eq "Books, science"
      end
      it "two" do
        science = create_category('science')
        create_category('rocket',science.id)
        visit root_path
        options("search_category_id",search_bar).should eq "Books, science, science/rocket"
      end
    end
  end

  context "search" do
    context "user not logged in" do
      before(:each) do
        @science = create_category('science')
        visit root_path
        fill_in 'Search', :with => 'Hood'
      end

      it "search added to database" do
        lambda do
          click_button 'Go'
        end.should change(Search,:count).by(1)
      end

      context "general category" do
        before(:each) do
          click_button 'Go'
        end
        it "category not set" do
          Search.last.category_id.should be_nil
        end
        it "redirect to the books index" do
          page.current_path.should eq books_path
        end
      end

      context "choose category" do  
        before(:each) do
          select 'science', :from => 'search_category_id'
          click_button 'Go'
        end
        it "category is set" do
          Search.last.category_id.should eq @science.id
        end
        it "redirect to that category page" do
          page.current_path.should eq category_path(@science)
        end
      end

      after(:each) do
        search = Search.last
        search.user_id.should be_nil
        search.ip.should eq '127.0.0.1'
        search.keywords.should eq 'Hood'
      end
    end

    context "user logged in" do
      before(:each) do
        @user = create_member(:email=>'member@example.com')
        login('member@example.com')
        @science = create_category('science')
        visit root_path
        fill_in 'Search', :with => 'Hood'
      end

      it "user is set" do
        click_button 'Go'
        Search.last.user_id.should eq @user.id
      end
    end
  end
end
