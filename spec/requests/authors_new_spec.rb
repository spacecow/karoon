require 'spec_helper'

describe "Authors" do
  describe "new" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit new_author_path
    end

    it "layout" do
      page.should have_title('New Author')      
      find_field('First Name').value.should be_nil
      find_field('Middle Names').value.should be_nil
      find_field('Last Name').value.should be_nil
      page.should have_button('Create Author')
    end 

    context "create author" do
      before(:each) do
        fill_in 'First Name', :with => 'Dean '
        fill_in 'Middle Names', :with => ' R.'
        fill_in 'Last Name', :with => ' Koontz '
      end

      it "adds an author to the database" do
        lambda do
          click_button 'Create Author'
        end.should change(Author,:count).by(1)
        Author.last.name.should eq "Dean R. Koontz"
      end

      it "gets redirected to the new author page" do
        click_button 'Create Author'
        page.current_path.should eq new_author_path
      end

      it "shows a flash message" do
        click_button 'Create Author'
        page.should have_notice("Author: 'Dean R. Koontz' was successfully created.")
      end
    end
  end
end
