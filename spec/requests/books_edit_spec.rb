require 'spec_helper'

describe "Books" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      @book = Factory(:book,:title=>"This is the Way",:summary => 'Test Summary',:regular_price=>1000)
      @book.categories << create_category('science')
      visit edit_book_path(@book)
    end

    it "layout" do
      page.should have_title('Edit Book')
      find_field('Title').value.should eq "This is the Way"
      find_field('Summary').value.should eq 'Test Summary'
      find_field('Regular Price').value.should eq '1000'
      find_field('Author').value.should be_nil 
      page.should have_button('Update Book')
    end

    context "edit book" do
      before(:each) do
        fill_in 'Title', :with => "No Way"
        fill_in 'Summary', :with => 'Edited Summary'
        fill_in 'Regular Price', :with => '900'
        fill_in 'Category', :with => 'rocket'
      end

      it "new version is saved to database" do
        author1 = create_author("Stephen King")
        author2 = create_author("Mark Twain")
        fill_in 'Author', :with => "#{author1.id}, #{author2.id}"
        lambda do
          lambda do
            click_button 'Update Book'
          end.should change(Category,:count).by(1)
        end.should change(Book,:count).by(0)
        book = Book.last
        book.title.should eq 'No Way'
        book.summary.should eq 'Edited Summary'
        book.regular_price.should eq "900"
        book.categories.map(&:name).should eq ["rocket"]
        book.authors.map(&:name).should eq ["Stephen King", "Mark Twain"]
      end

      context "error" do
        it "title cannot be blank" do
          fill_in 'Title', :with => ''
          click_button 'Update Book'
          li(:title).should have_blank_error
        end
        it "category cannot be left blank" do
          fill_in 'Category', :with => ''
          click_button 'Update Book'
          li(:category_tokens).should have_blank_error
        end
        it "regular price cannot be blank" do
          fill_in 'Price', :with => ''
          click_button 'Update Book'
          li(:regular_price).should have_blank_error
        end
        context "regular price must be a number" do
          it "in Toman" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
          end
          it "in Riel" do
            Setting.singleton.update_attribute(:currency,Setting::RIEL)
          end
          after(:each) do
            fill_in 'Price', :with => 'letters'
            click_button 'Update Book'
            li(:regular_price).should have_numericality_error
          end
        end
        context "regular price cannot be less than" do
          it "50 tomen" do
            Setting.singleton.update_attribute(:currency,Setting::TOMAN)
            fill_in 'Price', :with => 49 
            click_button 'Update Book'
            li(:regular_price).should have_greater_than_error(50)
          end
          it "500 Riel" do
            Setting.singleton.update_attribute(:currency,Setting::RIEL)
            fill_in 'Price', :with => 499 
            click_button 'Update Book'
            li(:regular_price).should have_greater_than_error(500)
          end
        end
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
