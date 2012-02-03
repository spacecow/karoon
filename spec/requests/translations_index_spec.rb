require 'spec_helper'

describe "Translations", :focus=>true do
  describe "index" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit translations_path
    end

    context "layout" do
      it "has a title" do
        page.should have_title('Translations')
      end

      it "has a subtitle" do
        page.should have_subtitle('New Translation')
      end
      it "has an empty key field" do
        value('Key').should be_nil
      end
      it "has an empty value field" do
        value('Value').should be_nil
      end
      it "has an empty locale field" do
        value('Locale').should be_nil
      end
      it "has a Create Translation button" do
        page.should have_button('Create Translation')
      end

      context "translation list" do
        it "empty -> has no div list" do
          page.should_not have_a_table('translations') 
        end
        context "non-empty" do
          it "has a div for the list" do
            create_translation('dog')
            visit translations_path
            page.should have_a_table('translations') 
          end
        end

        context "english" do
          before(:each) do
            create_translation('dog','Dog','en')
            visit translations_path
          end

          it "has two headers" do
            tableheader.should eq ['Key','English']
          end
          it "shows one row" do
            tablerow(0).should eq ['dog','Dog']
          end
        end

        context "english and persian" do
          before(:each) do
            create_translation('dog','Dog','en')
            create_translation('bbq','BBQ','ir')
            visit translations_path
          end

          it "has three headers" do
            tableheader.should eq ['Key','English','Persian']
          end
          it "shows two rows" do
            tablerow(0).should eq ['dog','Dog','-']
            tablerow(1).should eq ['bbq','-','BBQ']
          end
        end
      end
    end #layout

    context "links to" do
      context "edit translation" do
        before(:each) do
          TRANSLATION_STORE.flushdb
          create_translation('dog','Dog','en')
          visit translations_path
        end

        it "fill in a done translation" do
          cell(1,1).click_link 'Dog'
          value('Key').should eq 'dog' 
          value('Value').should eq 'Dog' 
          value('Locale').should eq 'en' 
        end
        context "fill in not yet done" do
          before(:each) do
            create_translation('bbq','BBQ','ir')
            visit translations_path
          end
          it "persian translation" do
            cell(1,2).click_link '-'
            value('Key').should eq 'dog' 
            value('Value').should be_nil 
            value('Locale').should eq 'ir' 
          end
          it "english translation" do
            cell(2,1).click_link '-'
            value('Key').should eq 'bbq' 
            value('Value').should be_nil 
            value('Locale').should eq 'en' 
          end
        end
      end
      it "hint with the english translation"
      it "list translations alphabetically"
    end

    context "create translation" do
      before(:each) do
        TRANSLATION_STORE.flushdb
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
      end
    end
  end
end
