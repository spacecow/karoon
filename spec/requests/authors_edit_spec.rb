require 'spec_helper'

describe "Authors" do
  describe "edit" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      @author = create_author('Dean R. Koontz')
      visit edit_author_path(@author)
    end

    it "layout" do
      page.should have_title('Edit Author')
      find_field('First Name').value.should eq "Dean"
      find_field('Middle Names').value.should eq "R."
      find_field('Last Name').value.should eq "Koontz"
      page.should have_button('Update Author')
    end

    context "edit author" do
      before(:each) do
        fill_in 'First Name', :with => "Stephen" 
        fill_in 'Middle Names', :with => "No Middle Names" 
        fill_in 'Last Name', :with => "King"
      end

      it "new version is saved to database" do
        lambda do
          click_button 'Update Author'
        end.should change(Author,:count).by(0)
        Author.last.name.should eq 'Stephen No Middle Names King'
      end

      it "name cannot be blank"

      it "shows a flash message" do
        click_button 'Update Author'
        page.should have_notice "Author: 'Stephen No Middle Names King' was successfully updated."
      end

      it "gets redirected to that author page" do
        click_button 'Update Author'
        page.current_path.should eq author_path(@author)
      end
    end
  end
end
