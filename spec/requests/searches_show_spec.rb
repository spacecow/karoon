require 'spec_helper'

describe "Searches" do
  context "show" do
    context "layout" do
      it "no category" do
        search = create_search('Hood')
        visit search_path(search)
        page.should have_title('Books')
      end
      it "category chosen" do
        novel = create_category('novel')
        search = create_search('Hood',novel.id)
        visit search_path(search)
        page.should have_title('novel')
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
  end
end
