require 'spec_helper'

describe "Searches" do
  context "'new'" do
    context "layout" do
      it "has a search button" do
        visit root_path
        search_bar.find_button('Go')
      end
      it "the keywords field is blank" do
        visit root_path
        search_bar.find_field('Search').value.should eq nil
      end
      it "the category is not selected" do
        visit root_path
        selected_value('search_category_id').should be_nil 
      end

      context "category options" do
        it "just contains 'Books' if no categories exists" do
          visit root_path
          options("search_category_id",search_bar).should eq "Books"
        end
        it "contains an existing category" do
          create_category('science')
          visit root_path
          options("search_category_id",search_bar).should eq "Books, science"
        end
        it "contains categories in order" do
          science = create_category('science')
          create_category('rocket',science.id)
          visit root_path
          options("search_category_id",search_bar).should eq "Books, science, science/rocket"
        end
      end
    end

    it "search with logged in user saves the user id" do
      @user = create_member(:email=>'member@example.com')
      login('member@example.com')
      visit root_path
      fill_in 'Search', :with => 'Hood'
      click_button 'Go'
      Search.last.user_id.should eq @user.id 
    end

    context "search" do
      before(:each) do
        @science = create_category('science')
        visit root_path
        fill_in 'Search', :with => 'Hood'
        select 'science', :from => 'search_category_id'
      end

      it "adds a search to the database" do
        lambda do
          click_button 'Go'
        end.should change(Search,:count).by(1)
      end

      it "user ip is saved" do
        click_button 'Go'
        Search.last.ip.should eq '127.0.0.1'
      end

      it "user id is not set if not logged in" do
        click_button 'Go'
        Search.last.user_id.should be_nil
      end

      context "category & search filled in" do
        before(:each){ click_button 'Go' }
        it "saves them to the database" do
          search = Search.last
          search.keywords.should eq 'Hood'
          search.category_id.should eq @science.id 
        end
        it "redirects to that search page" do
          current_path.should eq search_path(Search.last)
        end 
      end
      context "category filled in, search not," do
        before(:each) do
          fill_in 'Search', :with => ''
        end
        it "saves no category to the database" do
          lambda do
            click_button 'Go' 
          end.should change(Search,:count).by(0)
        end
        it "redirects to that category page" do
          click_button 'Go' 
          current_path.should eq category_path(@science)
        end 
      end
      context "search filled in, category not," do
        before(:each) do
          select 'Books', :from => 'search_category_id'
          click_button 'Go' 
          @search = Search.last
        end
        it "saves search to the database" do
          @search.keywords.should eq 'Hood' 
          @search.category_id.should be_nil 
        end
        it "redirects to that category page" do
          current_path.should eq search_path(@search)
        end 
      end
      context "category or search not filled in," do
        before(:each) do
          fill_in 'Search', :with => ''
          select 'Books', :from => 'search_category_id'
        end
        it "saves no category to the database" do
          lambda do
            click_button 'Go' 
          end.should change(Search,:count).by(0)
        end
        it "redirects to that category page" do
          click_button 'Go' 
          current_path.should eq books_path 
        end 
      end
    end
  end
end
