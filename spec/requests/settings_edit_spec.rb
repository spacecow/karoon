require 'spec_helper'

describe "Settings", :focus=>true do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit edit_setting_path(Setting.singleton)
    end

    it "layout" do
      page.should have_title("Edit Settings")
      options(:currency).should eq "BLANK, Riel, Toman" 
      selected_value('Currency').should be_nil
      page.should have_button("Update Settings")
    end 

    context "edit settings" do
      it "updates the setting in the database" do
        lambda do
          select 'Riel', :from => 'Currency'
          click_button 'Update Settings'
        end.should change(Setting,:count).by(0)
        Setting.singleton.currency.should eq "Riel"
      end

      it "generates a flash message"
      it "gets redirected to the edit setting page"
    end
  end
end
