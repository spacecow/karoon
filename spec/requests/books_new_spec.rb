require 'spec_helper'

describe "Books" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
    end
    
    context "layout" do
      it "regular" do
        visit new_book_path
        page.should have_title('New Book')
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

      it "currency in Riel" do
        Setting.singleton.update_attribute(:currency,Setting::RIEL)
        visit new_book_path
        li(:regular_price).should have_hint('in Riel')
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
        book.category.name.should eq 'science'
      end

      context "saves the price in Toman for" do
        it "Toman input" do
          Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          click_button 'Create Book'
          Book.last.regular_price.should eq "10000"
        end
        it "Riel input" do
          Setting.singleton.update_attribute(:currency,Setting::RIEL)
          click_button 'Create Book'
          Book.last.regular_price.should eq "1000"
        end
      end

      context "error" do
        it "title cannot be blank" do
          fill_in 'Title', :with => ''
          click_button 'Create Book'
          li(:title).should have_blank_error
        end
        it "title has to be unique" do
          create_book('New Title') 
          click_button 'Create Book'
          li(:title).should have_duplication_error
        end
        it "category cannot be left blank" do
          fill_in 'Category', :with => ''
          click_button 'Create Book'
          li(:category_tokens).should have_blank_error
        end
        it "regular price cannot be blank" do
          fill_in 'Price', :with => ''
          click_button 'Create Book'
          li(:regular_price).should have_blank_error
        end
        context "regular price must be a number" do
          it "in Toman" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          end
          it "in Riel" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          end
          after(:each) do
            fill_in 'Price', :with => 'letters'
            click_button 'Create Book'
            li(:regular_price).should have_numericality_error
            li(:regular_price).should_not have_greater_than_error(50)
          end
        end

        context "regular price cannot be less than" do
          it "50 tomen" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
            fill_in 'Price', :with => 49 
            click_button 'Create Book'
            li(:regular_price).should have_greater_than_error(50)
          end
          it "500 Riel" do
            Setting.singleton.update_attribute(:currency,Setting::RIEL)
            fill_in 'Price', :with => 499 
            click_button 'Create Book'
            li(:regular_price).should have_greater_than_error(500)
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
        it "category" do
          lambda do
            fill_in 'Category', :with => " space, #{@category.id}"
            click_button 'Create Book'
          end.should change(Category,:count).by(1)
          Book.last.categories.map(&:name).sort.should eq ['science','space']
        end
      end
    end
  end
end
