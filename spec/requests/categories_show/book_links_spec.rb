require 'spec_helper'

describe "Categories" do
  context "show, general book links" do
    before(:each) do
      @category = create_category('science')
      @way = create_book('This is the Way')
      @road = create_book('The Lonely Road')
      @category.books << @way 
      @category.books << @road
      visit category_path(@category)
    end

    it "book: This is the Way" do
      click_link('This is the Way')
      page.current_path.should eq book_path(@way)
    end

    it "book: The Lonely Road" do
      click_link 'The Lonely Road'
      page.current_path.should eq book_path(@road)
    end
  end
end
