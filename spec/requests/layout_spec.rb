require 'spec_helper'

describe "Sessions" do
  describe "root" do
    it "general layout" do
      visit root_path
      site_nav.should have_link('Books')
      site_nav.should have_link('Authors')
      site_nav.should have_link('Categories')
      user_nav.should_not have_link('Settings')
    end

    context "category listing" do
      before(:each) do
        @religion = create_category('religion')
        create_category('islam',@religion.id)
        @space = create_category('space')
        create_category('rocket',@space.id)
        @planet = create_category('planet',@space.id)
        create_category('Mars',@planet.id)
      end

      it "list base categories" do
        visit root_path
        li(li(site_nav,1)).should have_link('religion') 
        site_nav.should_not have_link('islam') 
        li(li(site_nav,1),1).should have_link('space') 
        site_nav.should_not have_link('rocket') 
        site_nav.should_not have_link('planet') 
        site_nav.should_not have_link('Mars') 
      end

      context "list tree:" do
        before(:each){ visit root_path }

        it "religion -" do
          site_nav.click_link 'religion'
          li(li(site_nav,1)).should have_link('religion') 
          site_nav.should_not have_link('space') 
          li(li(li(site_nav,1),1)).should have_link('islam') 
          site_nav.should_not have_link('rocket') 
          site_nav.should_not have_link('planet') 
          site_nav.should_not have_link('Mars') 
        end
        it "space -" do
          site_nav.click_link 'space'
          li(li(site_nav,1)).should have_link('space') 
          site_nav.should_not have_link('religion') 
          site_nav.should_not have_link('islam') 
          li(li(li(site_nav,1),1)).should have_link('planet') 
          li(li(li(site_nav,1),1),1).should have_link('rocket') 
          site_nav.should_not have_link('Mars') 
        end
        context "space - planet" do
          before(:each) do
            site_nav.click_link 'space'
            site_nav.click_link 'planet'
          end

          it "-" do end
          it "- Mars" do
            site_nav.click_link 'Mars'
          end

          after(:each) do
            li(li(site_nav,1)).should have_link('space') 
            site_nav.should_not have_link('religion') 
            site_nav.should_not have_link('islam') 
            li(li(li(site_nav,1),1)).should have_link('planet') 
            site_nav.should_not have_link('rocket') 
            li(li(li(li(site_nav,1),1),1)).should have_link('Mars') 
          end
        end
      end


      context "link to" do
        context "base category" do
          before(:each){ visit root_path }
          it "religion" do
            site_nav.click_link 'religion'
            page.current_path.should eq category_path(@religion)
          end
          it "space" do
            site_nav.click_link 'space'
            page.current_path.should eq category_path(@space)
          end
        end
        context "child category"
      end

      context "selection for" do
        before(:each) do
          visit root_path
        end

        context "Books" do
          it "by default" do end
          it "by clicking" do
            site_nav.click_link 'Books'
          end
          after(:each) do
            site_nav.find(:css,'.selected').text.should eq 'Books'
          end
        end 

        it "Authors" do
          site_nav.click_link 'Authors'
          site_nav.find(:css,'.selected').text.should eq 'Authors'
        end
        context "Categories" do
          it "base" do
            site_nav.click_link 'Categories'
            site_nav.find(:css,'.selected').text.should eq 'Categories'
          end
          context "religion" do
            it "root" do
              site_nav.click_link 'religion'
              site_nav.find(:css,'.selected').text.should eq 'religion'
            end
            it "islam" do
              site_nav.click_link 'religion'
              site_nav.click_link 'islam'
              site_nav.find(:css,'.selected').text.should eq 'islam'
            end
          end
          context "space" do
            it "root" do
              site_nav.click_link 'space'
              site_nav.find(:css,'.selected').text.should eq 'space'
            end
            it "rocket" do
              site_nav.click_link 'space'
              site_nav.click_link 'rocket'
              site_nav.find(:css,'.selected').text.should eq 'rocket'
            end
            it "planet" do
              site_nav.click_link 'space'
              site_nav.click_link 'planet'
              site_nav.find(:css,'.selected').text.should eq 'planet'
            end
          end
        end
      end

    end

    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit root_path
      user_nav.should have_link('Settings')
    end
  
    it "admin should be able to change from real to tomen in user profile"

    it "list categoris with indent in site nav"

    context "admin links to" do
      it "settings" do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit root_path
        user_nav.click_link 'Settings'
        page.current_path.should eq edit_setting_path(Setting.singleton)
      end
    end

    context "general links to" do
      before(:each) do
        visit root_path
      end

      it "books" do
        site_nav.click_link('Books')
        page.current_path.should eq books_path
      end
      it "authors" do
        site_nav.click_link('Authors')
        page.current_path.should eq authors_path
      end
      it "categories" do
        site_nav.click_link('Categories')
        page.current_path.should eq categories_path
      end
    end
  end
end
