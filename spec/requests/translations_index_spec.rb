require 'spec_helper'

describe "Translations" do
  describe "index" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      TRANSLATION_STORE.flushdb
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
      it "has no value hint" do
        li(:value).should_not have_hint
      end
      it "has an empty locale field" do
        value('Locale').should be_nil
      end
      it "has a Create Translation button" do
        page.should have_button('Create Translation')
      end

      context "translation list" do
        it "empty -> has no table" do
          page.should_not have_a_table('translations') 
        end
        context "non-empty" do
          it "has a table for the list" do
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
            value('english_0_value').should eq 'Dog'
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
            value('english_0_value').should be_nil 
            value('persian_0_value').should eq 'BBQ'
            value('english_1_value').should eq 'Dog'
            value('persian_1_value').should be_nil 
          end
        end
      end
    end #layout

    #context "links to" do
    #  context "edit translation" do
    #    before(:each) do
    #      create_translation('dog','Dog','en')
    #      create_translation('bbq','BBQ','ir')
    #      visit translations_path
    #    end

    #    it "fill in a done translation" do
    #      cell(2,1).click_link 'Dog'
    #      value('Key').should eq 'dog' 
    #      value('Value').should eq 'Dog' 
    #      value('Locale').should eq 'en' 
    #    end
    #    it "no hint if value is filled in" do
    #      cell(2,1).click_link 'Dog'
    #      li(:value).should_not have_hint
    #    end
    #    context "fill in not yet done" do
    #      it "persian translation" do
    #        cell(2,2).click_link '-'
    #        value('Key').should eq 'dog' 
    #        value('Value').should be_nil 
    #        value('Locale').should eq 'ir' 
    #      end
    #      it "english translation" do
    #        cell(1,1).click_link '-'
    #        value('Key').should eq 'bbq' 
    #        value('Value').should be_nil 
    #        value('Locale').should eq 'en' 
    #      end
    #    end

    #    context "hint with the english translation for" do
    #      it "persian translation" do
    #        cell(2,2).click_link '-'
    #        li(:value).should have_hint('English: Dog')
    #      end
    #      it "english translation" do
    #        cell(1,1).click_link '-'
    #        li(:value).should_not have_hint
    #      end
    #    end
    #  end
    #end
  end
end
