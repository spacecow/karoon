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
      find_field('Author').value.should be_nil 
      page.should have_button('Create Book')
    end

    context "create book" do
      before(:each) do
        @author = Factory(:author,:name=>"Test Author")
        fill_in 'Title', :with => 'New Title'
        fill_in 'Author', :with => @author.id 
      end

      it "adds a book to the database" do
        lambda do
          click_button('Create Book')
        end.should change(Book,:count).by(1)
        Book.last.title.should eq 'New Title'
        Book.last.author.to_s.should eq 'Test Author'
      end

      it "title cannot be blank" do
        fill_in 'Title', :with => ''
        click_button 'Create Book'
        li(:title).should have_blank_error
      end

      it "create an author on the fly" do
        lambda do
          fill_in 'Author', :with => " Basil Mouse, #{@author.id}"
          click_button 'Create Book'
        end.should change(Author,:count).by(1)
        Book.last.authors.map(&:name).sort.should eq ['Basil Mouse','Test Author']
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
