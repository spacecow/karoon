require 'spec_helper'

describe "Authors" do
  describe "index" do
    before(:each) do
      create_author 'Dean R. Koontz'
      @king = create_author 'Stephen King'
    end

    it "general layout" do
      visit authors_path
      tablecell(0,0).should eq 'Stephen King' 
      tablecell(1,0).should eq 'Dean R. Koontz' 
      page.should_not have_link('New Author')
      table.should_not have_link('Edit')
      table.should_not have_link('Del')
    end

    it "admin layout" do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      visit authors_path
      table.should have_link('Edit')
      table.should have_link('Del')
      page.should have_link('New Author')
    end

    context "admin links to" do
      before(:each) do
        create_admin(:email=>'admin@example.com')
        login('admin@example.com')
        visit authors_path
      end

      it "new author" do
        page.click_link 'New Author'
        page.current_path.should eq new_author_path
      end
  
      it "edit author" do
        row(0).click_link('Edit')
        page.current_path.should eq edit_author_path(@king)
      end

      it "delete author" do
        lambda do
          row(0).click_link('Del')
        end.should change(Author,:count).by(-1)
        Author.last.name.should eq 'Dean R. Koontz'
        page.should have_notice("Author: 'Stephen King' was successfully deleted.")
      end
    end
  end
end
