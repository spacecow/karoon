# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Books" do
  describe "new" do
    context "Toman on error form" do
      before(:each) do
        Setting.singleton.update_attribute(:currency,Setting::TOMAN)
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit new_book_path
      end

      it "regular price shows up in Toman" do
        fill_in 'Regular Price', :with => '1000' 
        click_button 'Create Book'
        find_field('Regular Price').value.should eq '1000'  
      end
      it "cannot be less than 50 tomen" do
        fill_in 'Price', :with => 49 
        click_button 'Create Book'
        li(:regular_price,0).should have_greater_than_error(50)
      end
    end
  
    context "Rial on error form" do
      before(:each) do
        Setting.singleton.update_attribute(:currency,Setting::RIAL)
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit new_book_path
      end

      it "regular price shows up in Rial" do
        fill_in 'Regular Price', :with => '10000' 
        click_button 'Create Book'
        find_field('Regular Price').value.should eq '1000'  
      end 
      it "cannot be less than 500 Rial" do
        fill_in 'Price', :with => 499 
        click_button 'Create Book'
        li(:regular_price,0).should have_greater_than_error(500)
      end
    end

    before(:each) do
      create_admin(:email=>'admin2@example.com')
      login('admin2@example.com')
    end
    
    context "layout" do
      it "regular" do
        visit new_book_path
        page.should have_title('New Book')
        divs(:book).count.should be(10)
        find_field('Title').value.should be_nil 
        find_field('Summary').value.should be_empty
        find_field('Regular Price').value.should be_nil
        find_field('Image').value.should be_nil
        find_field('Author').value.should be_nil 
        find_field('Category').value.should be_nil 
        page.should have_button('Create Book')
      end

      it "currency in Toman" do
        Setting.singleton.update_attribute(:currency,Setting::TOMAN)
        visit new_book_path
        li(:regular_price).should have_hint('in Toman')
      end

      it "currency in Rial" do
        Setting.singleton.update_attribute(:currency,Setting::RIAL)
        visit new_book_path
        li(:regular_price).should have_hint('in Rial')
      end
    end

    context "create book" do
      before(:each) do
        @author = create_author("Test Author")
        @category =  create_category("science")
        visit new_book_path
        fill_in 'Title', :with => 'New Title'
        fill_in 'Summary', :with => 'A stupid summary.'
        fill_in 'Regular Price', :with => 10000
        attach_file 'Image', 'spec/tree.png'
        fill_in 'Author', :with => @author.id 
        fill_in 'Category', :with => @category.id
      end

      it "adds a book to the database" do
        lambda do
          click_button 'Create Books'
        end.should change(Book,:count).by(1)
        book = Book.last
        book.title.should eq 'New Title'
        book.summary.should eq 'A stupid summary.'
        book.image_url.should eq "/uploads/book/image/#{book.id}/tree.png"
        book.image_url(:thumb).should eq "/uploads/book/image/#{book.id}/thumb_tree.png"
        book.author.name.should eq 'Test Author'
        book.category.name_en.should eq 'science'
      end

      context "saves the price in Toman for" do
        it "Toman input" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          click_button 'Create Book'
          Book.last.regular_price.should eq "10000"
        end
        it "Rial input" do
          Setting.singleton.update_attribute(:currency,Setting::RIAL)
          click_button 'Create Book'
          Book.last.regular_price.should eq "1000"
        end
      end

      context "error" do
        it "title cannot be blank" do
          fill_in 'Title', :with => ''
          click_button 'Create Book'
          li(:title,0).should have_blank_error
        end
        it "title has to be unique" do
          create_book('New Title') 
          click_button 'Create Book'
          li(:title,0).should have_duplication_error
        end
        it "category cannot be left blank" do
          fill_in 'Category', :with => ''
          click_button 'Create Book'
          li(:category_tokens,0).should have_blank_error
        end
        it "regular price cannot be blank" do
          fill_in 'Price', :with => ''
          click_button 'Create Book'
          li(:regular_price,0).should have_blank_error
        end
        context "regular price must be a number" do
          it "in Toman" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          end
          it "in Rial" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          end
          after(:each) do
            fill_in 'Price', :with => 'letters'
            click_button 'Create Book'
            li(:regular_price,0).should have_numericality_error
            li(:regular_price,0).should_not have_greater_than_error(50)
          end
        end



        context "on error form, alphabetical regular price shows up as" do
          it "Toman" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          end
          it "Rial" do
            Setting.singleton.update_attribute(:currency,Setting::RIAL)
          end 
          after(:each) do
            fill_in 'Title', :with => ''
            fill_in 'Regular Price', :with => 'letters' 
            click_button 'Create Book'
            find_field('Regular Price').value.should eq 'letters'  
          end
        end

      end
      context "create on the fly" do
        it "author" do
          lambda do
            fill_in 'Author', :with => " Basil Mouse, #{@author.id}"
            click_button 'Create Book'
          end.should change(Author,:count).by(1)
          Book.last.authors.map(&:name).sort.should eq ['Basil Mouse','Test Author']
        end
        context "category" do
          it "in egnlish" do
            lambda do
              fill_in 'Category', :with => " space, #{@category.id}"
              click_button 'Create Book'
            end.should change(Category,:count).by(1)
            Book.last.categories.map(&:name_en).sort.should eq ['science','space']
            Book.last.categories.map(&:names_depth_cache_en).sort.should eq ['science','space']
          end

          it "in persian" do
            user_nav.click_link 'Persian'
            lambda do
              fill_in 'Title', :with => 'New Title'
              fill_in 'Regular Price', :with => 10000
              fill_in 'Category', :with => " space, #{@category.id}"
              click_button 'Create کتابها'
            end.should change(Category,:count).by(1)
            Book.last.categories.map(&:name_ir).compact.should eq ['space']
            Book.last.categories.map(&:names_depth_cache_ir).sort.should eq ['science','space']
          end
        end
      end
    end
  end
end
