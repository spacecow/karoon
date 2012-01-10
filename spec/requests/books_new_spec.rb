require 'spec_helper'

describe "Books" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit new_book_path
    end

    it "book layout" do
      page.should have_title('New Book')
      find_field('Title').value.should be_nil 
      find_field('Summary').value.should be_empty
      find_field('Regular Price').value.should be_nil
      li(:regular_price).should have_hint('in toman')
      find_field('Image').value.should be_nil
      find_field('Author').value.should be_nil 
      find_field('Category').value.should be_nil 
      page.should have_button('Create Book')
    end

    context "create book" do
      before(:each) do
        @author = create_author("Test Author")
        @category =  create_category("science")
        fill_in 'Title', :with => 'New Title'
        fill_in 'Summary', :with => 'A stupid summary.'
        fill_in 'Regular Price', :with => 10000
        attach_file 'Image', 'spec/tree.png'
        fill_in 'Author', :with => @author.id 
        fill_in 'Category', :with => @category.id
      end

      it "adds a book to the database" do
        lambda do
          click_button('Create Book')
        end.should change(Book,:count).by(1)
        book = Book.last
        book.title.should eq 'New Title'
        book.summary.should eq 'A stupid summary.'
        book.regular_price.should eq 10000
        book.image_url.should eq "/uploads/book/image/#{book.id}/tree.png"
        book.image_url(:thumb).should eq "/uploads/book/image/#{book.id}/thumb_tree.png"
        book.author.name.should eq 'Test Author'
        book.category.name.should eq 'science'
      end

      context "error" do
        it "title cannot be blank" do
          fill_in 'Title', :with => ''
          click_button 'Create Book'
          li(:title).should have_blank_error
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
        it "regular price must be a number" do
          fill_in 'Price', :with => 'letters'
          click_button 'Create Book'
          li(:regular_price).should have_greater_than_error(50)
        end
        it "regular price cannot be less than 50 tomen" do
          fill_in 'Price', :with => 49 
          click_button 'Create Book'
          li(:regular_price).should have_error('must be greater than 50')
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

      it "shows a flash message" do
        click_button 'Create Book'
        page.should have_notice("Book: 'New Title' was successfully created.")
      end

      it "gets redirected back to the new book page" do
        click_button 'Create Book'
        page.current_path.should eq new_book_path
      end
    end
  end
end
