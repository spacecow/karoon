require 'spec_helper'

describe "Books" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      Factory(:author,:first_name=>"Test",:last_name=>"Author")
      visit new_book_path
    end

    it "layout" do
      page.should have_title('New Book')
      find_field('Title').value.should be_nil 
      options('Author').should eq "BLANK, Test Author"
      page.should have_button('Create Book')
    end

    context "create book" do
      before(:each) do
        fill_in 'Title', :with => 'New Title'
        select 'Test Author', :from => 'Author'
      end

      it "adds a book to the database" do
        lambda do
          click_button('Create Book')
        end.should change(Book,:count).by(1)
      end

      it "title gets set" do
        click_button('Create Book')
        Book.last.title.should eq 'New Title'
      end

      it "author gets set" do
        click_button('Create Book')
        Book.last.author.to_s.should eq 'Test Author'
      end

      it "title cannot be blank" do
        fill_in 'Title', :with => ''
        click_button('Create Book')
        li(:title).should have_blank_error
      end

      it "shows a flash message" do
        click_button('Create Book')
        page.should have_notice('Successfully created Book.')
      end
    end
  end
end
