require 'spec_helper'

describe "Translations" do
  describe "index" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      create_translation('bbq','BBQ','ir')
      create_translation('dog','Dog','en')
      visit translations_path
    end

    it "update translations" do
      fill_in 'en_0_value', :with => 'bbqing' 
      fill_in 'ir_1_value', :with => 'doggy' 
      click_button 'Update Translations'
      value(:en_0_value).should eq 'bbqing'
      value(:ir_0_value).should eq 'BBQ'
      value(:en_1_value).should eq 'Dog'
      value(:ir_1_value).should eq 'doggy'
    end
  end
end
