require 'spec_helper'

describe "Books" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      @book = Factory(:book,:title=>"This is the Way")
      visit edit_book_path(@book)
    end

    it "layout" do
      page.should have_title('Edit Book')
      find_field('Title').value.should eq "This is the Way"
      find_field('Author').value.should be_nil 
      page.should have_button('Update Book')
    end

    context "edit book" do
      before(:each) do
        fill_in 'Title', :with => "No Way" 
      end

      it "new version is saved to database" do
        author1 = create_author("Stephen King")
        author2 = create_author("Mark Twain")
        fill_in 'Author', :with => "#{author1.id}, #{author2.id}"
        lambda do
          click_button 'Update Book'
        end.should change(Book,:count).by(0)
        Book.last.title.should eq 'No Way'
        Book.last.authors.map(&:name).should eq ["Stephen King", "Mark Twain"]
      end

      it "title cannot be blank" do
        fill_in 'Title', :with => ''
        click_button 'Update Book'
        li(:title).should have_blank_error
      end

      it "shows a flash message" do
        click_button 'Update Book'
        page.should have_notice("Book: 'No Way' was successfully updated.")
      end

      it "gets redirected to that book page" do
        click_button 'Update Book'
        page.current_path.should eq book_path(@book)
      end
    end
  end
end
