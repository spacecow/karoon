
require 'spec_helper'

describe "Books" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      book = Factory(:book,:title=>"This is the Way")
      visit edit_book_path(book)
    end

    it "layout" do
      page.should have_title('Edit Book')
      find_field('Title').value.should eq "This is the Way"
      find_field('Author').value.should be_nil 
      page.should have_button('Update Book')
    end
  end
end
