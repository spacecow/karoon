# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Carts" do
  describe "show" do
    before(:each) do
      visit root_path
      @cart = Cart.last
    end

    context "layout, empty cart" do
      before(:each){ visit cart_path(@cart) }

      it "title is set to 'Your Cart'" do
        page.should have_title('Your Cart')
      end

      it "should have an empty cart button" do
        page.should have_button('Empty Cart')
      end

      it "should have an update cart button" do
        page.should have_button('Update Cart')
      end

      it "shows a messages saying cart is emtpy" do
        div('cart').should have_content('Your cart is currently empty.')
      end

      it "no total should be visible" do
        div('cart').should_not have_div('total')
      end

      it "what happends if a book quantity is more than ten?"
    end #layout, empty cart
    
    context "layout, categories" do
      before(:each) do
        @book = create_book
        @book.categories.destroy_all
        @cart.line_items.create!(:book_id=>@book.id)
      end

      it "none" do
        visit cart_path(@cart)
        div(:line_item,0).div(:categories).should have_content('Categories: -')
      end

      context "one, in" do
        before(:each) do
          @book.categories << create_category('programming')
          visit cart_path(@cart)
        end

        it "english" do
          div(:line_item,0).div(:categories).should have_content('Category: programming')
          div(:line_item,0).div(:categories).should have_link('programming')
        end
        it "persian" do
          user_nav.click_link 'Persian'
          div(:line_item,0).div(:categories).should have_content('موضوعها: برنامه‌نویسی')
          div(:line_item,0).div(:categories).should have_link('برنامه‌نویسی')
        end
      end
    end
  end #show
end
