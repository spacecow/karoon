# encoding: utf-8

require 'spec_helper'

describe "Sessions" do
  describe "root" do
    it "a book categorized as religion/islam should show up as religion as well"

    it "general layout" do
      visit root_path
      site_nav.should have_link('Books')
      site_nav.should have_link('Authors')
      site_nav.should have_link('Categories')
      site_nav.should_not have_link('Translations')
      search_bar.should have_image('My_cart_e')
      user_nav.should_not have_link('Settings')
      user_nav.should_not have_link('Searches')
      user_nav.should have_link('فارسی')
      user_nav.should_not have_link('My Account')
    end

    it "member layout" do
      login_member
      visit root_path
      user_nav.should have_link('My Account')
    end

    context "category listing" do
      before(:each) do
        @religion = create_category('religion')
        create_category('islam',@religion.id)
        @space = create_category('space')
        create_category('rocket launcher',@space.id)
        @planet = create_category('planet',@space.id)
        create_category('Mars',@planet.id)
      end

      it "list base categories" do
        visit root_path
        site_nav.li(1).li.should have_link('religion')
        site_nav.should_not have_link('islam') 
        site_nav.li(1).li(1).should have_link('space')
        site_nav.should_not have_link('rocket launcher') 
        site_nav.should_not have_link('planet') 
        site_nav.should_not have_link('Mars') 
      end

      context "list tree:" do
        before(:each){ visit root_path }

        it "religion -" do
          site_nav.click_link 'religion'
          site_nav.li(1).li.should have_link('religion') 
          site_nav.should_not have_link('space') 
          site_nav.li(1).li(1).li.should have_link('islam') 
          site_nav.should_not have_link('rocket launcher') 
          site_nav.should_not have_link('planet') 
          site_nav.should_not have_link('Mars') 
        end
        it "space -" do
          site_nav.click_link 'space'
          site_nav.li(1).li.should have_link('space') 
          site_nav.should_not have_link('religion') 
          site_nav.should_not have_link('islam') 
          site_nav.li(1).li(1).li.should have_link('planet') 
          site_nav.li(1).li(1).li(1).should have_link('rocket launcher') 
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
            site_nav.li(1).li.should have_link('space') 
            site_nav.should_not have_link('religion') 
            site_nav.should_not have_link('islam') 
            site_nav.li(1).li(1).li.should have_link('planet') 
            site_nav.should_not have_link('rocket launcher') 
            site_nav.li(1).li(1).li(1).li.should have_link('Mars') 
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
        it "child category"
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
        it "Translations" do
          create_admin(:email=>'admin@example.com')
          login('admin@example.com')
          visit root_path
          site_nav.click_link 'Translations'
          site_nav.find(:css,'.selected').text.should eq 'Translations'
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
            it "rocket launcher" do
              site_nav.click_link 'space'
              site_nav.click_link 'rocket launcher'
              site_nav.find(:css,'.selected').text.should eq 'rocket launcher'
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
      site_nav.should have_link('Translations')
      user_nav.should have_link('Settings')
      user_nav.should have_link('Searches')
    end
  
    it "admin should be able to change from real to tomen in user profile"

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit root_path
      end
      it "settings" do
        user_nav.click_link 'Settings'
        page.current_path.should eq edit_setting_path(Setting.singleton)
      end
      it "searches" do
        user_nav.click_link 'Searches'
        page.current_path.should eq searches_path 
      end
      it "translations" do
        site_nav.click_link 'Translations'
        page.current_path.should eq translations_path
      end
    end

    context "member links to" do
      before(:each) do
        @member = login_member
        visit root_path
      end

      it "my account" do
        user_nav.click_link 'My Account'
        current_path.should eq user_path(@member)
      end
    end

    context "general links to" do
      before(:each) do
        visit root_path
      end

      it "root, by clicking on the logo" do
        click_link('Blue_logo')
        current_path.should eq root_path
      end
      it "books" do
        site_nav.click_link('Books')
        current_path.should eq books_path
      end
      it "authors" do
        site_nav.click_link('Authors')
        current_path.should eq authors_path
      end
      it "categories" do
        site_nav.click_link('Categories')
        current_path.should eq categories_path
      end
      it "my cart" do
        search_bar.click_link('My_cart_e')
        current_path.should eq cart_path(Cart.last)
      end
      it "persian" do
        user_nav.click_link 'فارسی'
        user_nav.should have_link('English')
      end
    end
  end
end
