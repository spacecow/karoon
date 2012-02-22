require 'spec_helper'

describe "Translations" do
  describe "index" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      TRANSLATION_STORE.flushdb
      visit translations_path
    end

    #it "creating a category updates the category model" do
    #  locale = create_locale('en.categories')
    #  create_category('java')
    #  Category.last.names_depth_cache_en.should eq "translation missing: en.categories.java"
    #  fill_in 'Key', :with => 'java'
    #  fill_in 'Value', :with => 'java'
    #  fill_in 'Locale', :with => locale.id 
    #  click_button 'Create Translation'
    #  Category.last.names_depth_cache_en.should eq 'java'
    #end 

    context "create translation" do
      before(:each) do
        locale = create_locale('en')
        fill_in 'Key', :with => 'action'
        fill_in 'Value', :with => 'Action'
        fill_in 'Locale', :with => locale.id 
      end

      it "adds no translation to the database" do
        lambda do
          click_button 'Create Translation'
        end.should change(Translation,:count).by(0)
      end
      it "adds no locale to the database" do
        lambda do
          click_button 'Create Translation'
        end.should change(Locale,:count).by(0)
      end

      it "sets the key" do
        click_button 'Create Translation'
        TRANSLATION_STORE.keys.should eq ['en.action']
      end
      it "sets the value" do
        click_button 'Create Translation'
        TRANSLATION_STORE['en.action'].should eq '"Action"'
      end

      context "create locale on the fly" do
        before(:each) do
          fill_in 'Locale', :with => 'en.messages'
        end

        it "adds a locale to the database" do
          lambda do
            click_button 'Create Translation'
          end.should change(Locale,:count).by(1)
        end
        it "sets the locale" do
          click_button 'Create Translation'
          Locale.last.name.should eq 'en.messages'
        end
      end

      context "errors:" do
        it "key cannot be blank" do
          fill_in 'Key', :with => ''
          click_button 'Create Translation'
          li(:key).should have_blank_error
        end
        it "value cannot be blank" do
          fill_in 'Value', :with => ''
          click_button 'Create Translation'
          li(:value).should have_blank_error
        end
        it "locale cannot be blank" do
          fill_in 'Locale', :with => ''
          click_button 'Create Translation'
          li(:locale).should have_blank_error
        end
      end #errors
    end #create translation
  end #index
end
