# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Orders" do
  describe "new" do
    before(:each) do
      create_member(:email=>'member@example.com')
      login('member@example.com')
      cart = Cart.last
      @book = create_book 
      item = cart.line_items.create!(:book_id=>@book.id)
    end

    context "layout" do
      before(:each){ visit new_order_path }

      it "tile is set" do
        page.should have_title('New Order')
      end

      it "has a create button" do
        page.should have_button('Create Order')
      end
      it "has a cancel button" do
        page.should have_button('Cancel Order')
      end
    end

    context "layout, categories" do
      before(:each) do
        @book.categories.destroy_all
      end

      it "none" do
        visit new_order_path 
        div(:line_item,0).div(:categories).should have_content('Categories: -')
      end

      context "one, in" do
        before(:each) do
          @book.categories << create_category('programming')
          visit new_order_path
        end

        it "english" do
          div(:line_item,0).div(:categories).should have_content('Category: programming')
          div(:line_item,0).div(:categories).should_not have_link('programming')
        end
        it "persian" do
          user_nav.click_link 'Persian'
          div(:line_item,0).div(:categories).should have_content('برنامه‌نویسی')
          div(:line_item,0).div(:categories).should_not have_link('برنامه‌نویسی')
        end
      end
    end
  end
end
