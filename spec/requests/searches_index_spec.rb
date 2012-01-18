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
          div(div(:search,0),:ip).text.should eq '127.0.0.1'
        end
        context "userid" do
          it "displayed, if there is one" do
            Factory(:search,:keywords=>'Hood',:user_id=>@admin.id)
            visit searches_path
            div(div(:search,0),:userid).text.should eq 'admin@example.com'
          end
          it "not displayed if anonymous search" do
            div(:search,0).should_not have_div(:userid)
          end
        end
      end
    end
  end
end
