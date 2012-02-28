require 'spec_helper'

describe "Searches" do
  context "show" do
    context "layout" do
      context "no category" do
        before(:each) do
          search = create_search('Hood')
          visit search_path(search)
        end
        it "Books is set as title" do
          page.should have_title('Books')
        end
        it "the search stays in the search field but no category is chosen" do
          search_bar.find_field('Search').value.should eq 'Hood'
          selected_value('search_category_id').should be_blank 
        end
      end
      context "category chosen" do
        before(:each) do
          @novel = create_category('novel')
          search = create_search('Hood',@novel.id)
          visit search_path(search)
        end
        it "the category is set as title" do
          page.should have_title('novel')
        end
        it "the search stays in the search field and a category is chosen" do
          search_bar.find_field('Search').value.should eq 'Hood'
          selected_value('search_category_id').should eq @novel.id.to_s 
        end
      end

      context "hits" do
        before(:each) do
          create_book('Robin Hood')
          create_book('Hooden Boy')
          boya = create_book('Japanese Boya')
          @japanese = create_category('japanese')
          boya.categories << @japanese
        end
        it "0" do
          search = create_search('Santa')
          visit search_path(search)
          page.should have_subtitle("Search: 'Santa'. 0 Hits.")
        end
        it "1 general" do
          search = create_search('Robin Hood')
          visit search_path(search)
          page.should have_subtitle("Search: 'Robin Hood'. 1 Hit.")
        end
        it "2 general" do
          search = create_search('Hood')
          visit search_path(search)
          page.should have_subtitle("Search: 'Hood'. 2 Hits.")
        end
        it "1 categorized" do
          search = create_search('Boy',@japanese.id)
          visit search_path(search)
          page.should have_subtitle("Search: 'Boy'. 1 Hit.")
        end
      end
    end

    context "links" do
      context "navigation to an author saves that action to" do
        it "a new search" do
          hood = create_book('Robin Hood')
          king = create_author('Stephen King')
          hood.authors << king
          search = create_search('Hood')
          visit search_path(search)
          click_link 'Stephen King'
          Search.last.author_match.should eq [king.id,'Stephen King'].to_json
        end
        it "an old search" do
          hood = create_book('Robin Hood')
          king = create_author('Stephen King')
          hood.authors << king
          search = create_search('Hood')
          search.update_attribute(:author_match,[1,'Yeah'].to_json)
          visit search_path(search)
          click_link 'Stephen King'
          Search.last.author_match.should eq [1,'Yeah',king.id,'Stephen King'].to_json
        end
      end
      context "navigation to a book saves that action to" do
        it "a new search" do
          hood = create_book('Robin Hood')
          search = create_search('Hood')
          visit search_path(search)
          click_link 'Robin Hood'
          Search.last.book_match.should eq [hood.id,'Robin Hood'].to_json
        end
        it "an old search" do
          hood = create_book('Robin Hood')
          search = create_search('Hood')
          search.update_attribute(:book_match,[1,'Yeah'].to_json)
          visit search_path(search)
          click_link 'Robin Hood'
          Search.last.book_match.should eq [1,'Yeah',hood.id,'Robin Hood'].to_json
        end
      end
      context "navigation to a category saves that action to" do
        it "a new search" do
          hood = create_book('Robin Hood')
          science = create_category('science')
          hood.categories << science
          search = create_search('Hood')
          visit search_path(search)
          click_link 'science'
          Search.last.category_match.should eq [science.id,'science'].to_json
        end
        it "an old search" do
          hood = create_book('Robin Hood')
          science = create_category('science')
          hood.categories << science
          search = create_search('Hood')
          search.update_attribute(:category_match,[1,'Yeah'].to_json)
          visit search_path(search)
          click_link 'science'
          Search.last.category_match.should eq [1,'Yeah',science.id,'science'].to_json
        end
      end
    end
  end
end
