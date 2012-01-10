require 'spec_helper'

describe "Settings" do
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
      before(:each) do
        select 'Riel', :from => 'Currency'
      end

      it "updates the setting in the database" do
        lambda do
          click_button 'Update Settings'
        end.should change(Setting,:count).by(0)
        Setting.singleton.currency.should eq "Riel"
      end

      it "generates a flash message" do
        click_button 'Update Settings'
        page.should have_notice('Settings was successfully updated.')
      end

      it "redirects to the edit setting page" do
        click_button 'Update Settings'
        page.current_path.should eq edit_setting_path(Setting.singleton)
      end
    end
  end
end
