# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Searches" do
  context "'new'" do
    context "layout, no categories" do
      before(:each) do
        visit root_path
      end

      it "has a search button" do
        search_bar.find_button('Go')
      end
      it "the keywords field is blank" do
        search_bar.find_field('Search').value.should eq nil
      end
      it "no category is not selected" do
        selected_value('search_category_id').should be_empty 
      end

      it "categories just contains 'Books'" do
        search_bar.options("search_category_id").should eq "Books"
      end

      context "layout, one category" do
        context "categories have two options in" do
          before(:each) do
            create_category('science')
            visit root_path
          end

          it "english" do
            search_bar.options("search_category_id").should eq "Books, science"
          end
          it "persian" do
            user_nav.click_link 'Persian'
            search_bar.options("search_category_id").should eq 'کتابها, علم'
          end
        end
      end

      context "layout, two categories" do
        context "categories have three options in" do
          before(:each) do
            science = create_category('science')
            create_category('rocket_launcher',science.id)
            visit root_path
          end

          it "english" do
            search_bar.options("search_category_id").should eq "Books, science, science/rocket launcher"
          end
          it "persian" do
            user_nav.click_link 'Persian'
            search_bar.options("search_category_id").should eq 'کتابها, علم, علم\راکت'
          end
        end
      end
    end
  end
end
