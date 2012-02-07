# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Translations" do
  describe "index" do
    before(:each) do
      create_admin(:email=>'admin@example.com')
      login('admin@example.com')
      TRANSLATION_STORE.flushdb
    end

    context "update translation" do
      before(:each) do
        create_category('rock_science')
      end

      it "english" do
        I18n.backend.store_translations('en.categories', {'rock_science' => 'rock_science'}, :escape => false)
        visit translations_path
        Category.last.names_depth_cache_en.should eq "translation missing: en.categories.rock_science"
        fill_in 'english_0_value', :with => 'Rock Science'
        click_button 'Update Translations'
        Category.last.names_depth_cache_en.should eq "Rock Science"
      end 

      it "persian" do
        I18n.backend.store_translations('ir.categories', {'rock_science' => 'rock_science'}, :escape => false)
        visit translations_path
        Category.last.names_depth_cache_ir.should eq "translation missing: ir.categories.rock_science"
        fill_in 'persian_0_value', :with => 'علم'
        click_button 'Update Translations'
        Category.last.names_depth_cache_ir.should eq 'علم'
      end 
    end
  end
end
