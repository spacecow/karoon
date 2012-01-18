require 'spec_helper'

describe "Searches", :focus=>true do
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
          Factory(:search,:keywords=>'Hood',:ip=>'127.0.0.1')
          visit searches_path
          div(div(:search,0),:ip).should have_content('IP: 127.0.0.1')
        end
        context "userid" do
          it "displayed, if there is one" do
            Factory(:search,:keywords=>'Hood',:user_id=>@admin.id)
            visit searches_path
            div(div(:search,0),:userid).should have_content('Userid: admin@example.com')
          end
          it "not displayed if anonymous search" do
            Factory(:search,:keywords=>'Hood')
            visit searches_path
            div(:search,0).should_not have_div(:userid)
          end
        end
        context "book links" do
          it "displayed, if there are any" do
            hood = create_book('Robin Hood')
            Factory(:search,:book_match=>[hood.id,hood.title].to_json) 
            visit searches_path
            #div(:search,0).should have_content('Book Match: Robin Hood')
          end
          it "not displayed if no links are stored" do
            Factory(:search,:keywords=>'Hood')
            visit searches_path
            div(:search,0).should_not have_div(:book_match)
          end
        end
      end
    end
  end
end
