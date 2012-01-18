require 'spec_helper'

describe "Searches" do
  context "'index'" do
    before(:each) do
      @admin = create_admin(:email=>'admin@example.com')
      login('admin@example.com')
    end

    context "layout" do
      it "has a 'Searches' title" do
        visit searches_path
        page.should have_title('Searches')
      end
      context "searches listing" do
        it "displays the ip address" do
          Factory(:search,:ip=>'127.0.0.1')
          visit searches_path
          search_ip(0).should have_content('IP: 127.0.0.1')
        end
        it "displays the keywords" do
          Factory(:search,:keywords=>'Hood')
          visit searches_path
          search_keywords(0).should have_content('Hood')
        end
        context "userid" do
          it "displayed, if there is one" do
            Factory(:search,:user_id=>@admin.id)
            visit searches_path
            search_userid(0).should have_content('Userid: admin@example.com')
          end
          it "not displayed if anonymous search" do
            Factory(:search)
            visit searches_path
            search(0).should_not have_div(:userid)
          end
        end
        context "author match" do
          it "displayed, if one" do
            Factory(:search,:author_match=>[1,'Stephen King'].to_json) 
            visit searches_path
            search_author_match(0).should have_content('Author Match: Stephen King')
            search_author_match(0).should have_link('Stephen King')
          end
          it "displayed, if many" do
            Factory(:search,:author_match=>[1,'Stephen King',2,'Dean R. Koontz'].to_json) 
            visit searches_path
            search_author_match(0).should have_content('Author Match: Stephen King, Dean R. Koontz')
            search_author_match(0).should have_link('Stephen King')
            search_author_match(0).should have_link('Dean R. Koontz')
          end
          it "not displayed if no links are stored" do
            Factory(:search)
            visit searches_path
            search(0).should_not have_div(:author_match)
          end
        end
        context "book match" do
          it "displayed, if one" do
            Factory(:search,:book_match=>[1,'Robin Hood'].to_json) 
            visit searches_path
            search_book_match(0).should have_content('Book Match: Robin Hood')
            search_book_match(0).should have_link('Robin Hood')
          end
          it "displayed, if many" do
            Factory(:search,:book_match=>[1,'Robin Hood',2,'Hooded Boy'].to_json) 
            visit searches_path
            search_book_match(0).should have_content('Book Match: Robin Hood, Hooded Boy')
            search_book_match(0).should have_link('Robin Hood')
            search_book_match(0).should have_link('Hooded Boy')
          end
          it "not displayed if no links are stored" do
            Factory(:search)
            visit searches_path
            search(0).should_not have_div(:book_match)
          end
        end
        context "category match" do
          it "displayed, if one" do
            Factory(:search,:category_match=>[1,'science'].to_json) 
            visit searches_path
            search_category_match(0).should have_content('Category Match: science')
            search_category_match(0).should have_link('science')
          end
          it "displayed, if many" do
            Factory(:search,:category_match=>[1,'science',2,'rocket'].to_json) 
            visit searches_path
            search_category_match(0).should have_content('Category Match: science, rocket')
            search_category_match(0).should have_link('science')
            search_category_match(0).should have_link('rocket')
          end
          it "not displayed if no links are stored" do
            Factory(:search)
            visit searches_path
            search(0).should_not have_div(:category_match)
          end
        end
      end
    end
    context "links to" do
      context "author match" do
        before(:each) do
          @king = create_author('Stephen King')
        end
        it "first" do
          Factory(:search,:author_match=>[@king.id,'Stephen King'].to_json) 
          visit searches_path
          search_author_match(0).click_link 'Stephen King'
          page.current_path.should eq author_path(@king)
        end
        it "second" do
          koontz = create_author('Dean R. Koontz')
          Factory(:search,:author_match=>[@king.id,'Stephen King',koontz.id,'Dean R. Koontz'].to_json) 
          visit searches_path
          search_author_match(0).click_link 'Dean R. Koontz'
          page.current_path.should eq author_path(koontz)
        end
      end
      context "books match" do
        before(:each) do
          @hood = create_book('Robin Hood')
        end
        it "first" do
          Factory(:search,:book_match=>[@hood.id,'Robin Hood'].to_json) 
          visit searches_path
          search_book_match(0).click_link 'Robin Hood'
          page.current_path.should eq book_path(@hood)
        end
        it "second" do
          boy = create_book('Hooded Boy')
          Factory(:search,:book_match=>[@hood.id,'Robin Hood',boy.id,'Hooded Boy'].to_json) 
          visit searches_path
          search_book_match(0).click_link 'Hooded Boy'
          page.current_path.should eq book_path(boy)
        end
      end
      context "category match" do
        before(:each) do
          @science = create_category('science')
        end
        it "first" do
          Factory(:search,:category_match=>[@science.id,'science'].to_json) 
          visit searches_path
          search_category_match(0).click_link 'science'
          page.current_path.should eq category_path(@science)
        end
        it "second" do
          rocket = create_category('rocket')
          Factory(:search,:category_match=>[@science.id,'science',rocket.id,'rocket'].to_json) 
          visit searches_path
          search_category_match(0).click_link 'rocket'
          page.current_path.should eq category_path(rocket)
        end
      end
    end
  end
end
