require 'spec_helper'

describe "Settings" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
    end

    context "layout" do
      it "general" do
        visit edit_setting_path(Setting.singleton)
        page.should have_title("Edit Settings")
        options('Currency').should eq "BLANK, Rial, Toman" 
        page.should have_button("Update Settings")
      end
      
      context "selected currency" do
        it "in Toman" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          visit edit_setting_path(Setting.singleton)
          selected_value('Currency').should eq "toman"
        end
        it "in Rial" do
          Setting.singleton.update_attribute(:currency,Setting::RIAL)
          visit edit_setting_path(Setting.singleton)
          selected_value('Currency').should eq "rial"
        end
        it "nil" do
          Setting.singleton.update_attribute(:currency,nil)
          visit edit_setting_path(Setting.singleton)
          selected_value('Currency').should be_empty
        end
      end
    end 

    context "edit settings" do
      before(:each) do
        visit edit_setting_path(Setting.singleton)
        select 'Rial', :from => 'Currency'
      end

      it "updates the setting in the database" do
        lambda do
          click_button 'Update Settings'
        end.should change(Setting,:count).by(0)
        Setting.singleton.currency.should eq "rial"
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
