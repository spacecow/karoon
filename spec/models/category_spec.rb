# -*- coding: utf-8 -*-
require 'spec_helper'

describe Category do
  context "#parent" do
    before(:each) do
      @religion = create_category('religion')
    end

    it "cannot set parent to oneself" do
      @religion.update_attributes(:parent_id=>@religion.id) 
      @religion.errors_on(:parent_id).should eq ["cannot be a descendant of itself."]
    end

    it "cannot set parent to a child" do
      mantra = create_category('mantra',@religion.id)
      @religion.update_attributes(:parent_id=>mantra.id) 
      @religion.errors_on(:parent_id).should eq ["cannot be a descendant of itself."]
    end
  end

  context "#names_depth_cache" do
    context "every time a category gets saved, its path is saved in #names_depth_cache for" do
      context "english" do
        before(:each) do
          Factory(:category, name_en:'programming')
        end
        it "one category in english" do
          Category.last.names_depth_cache_en.should eq 'programming'
        end
        it "one category in persian" do
          Category.last.names_depth_cache_ir.should eq 'programming'
        end
      end

      context "persian" do
        before(:each) do
          Factory(:category, name_ir:'programming')
        end
        it "one category in english" do
          Category.last.names_depth_cache_en.should eq 'programming'
        end
        it "one category in persian" do
          Category.last.names_depth_cache_ir.should eq 'programming'
        end
      end

      context "persian and english" do
        before(:each) do
          Factory(:category, name_en:'programming', name_ir:'prog.')
        end
        it "one category in english" do
          Category.last.names_depth_cache_en.should eq 'programming'
        end
        it "one category in persian" do
          Category.last.names_depth_cache_ir.should eq 'prog.'
        end
      end

      context "two categories in" do
        before(:each) do
          programming = create_category('programming')
          create_category('ruby',programming.id)
        end

        it "english" do
          Category.last.names_depth_cache_en.should eq 'programming/ruby'  
        end
        it "persian" do
          Category.last.names_depth_cache_ir.should eq 'programming\ruby'  
        end
      end
    end

    context "if the name of a root category changes, the #names_depth_cache for" do
      context "the root should be changed for" do
        before(:each) do
          programming = create_category('programming')
          programming.update_attribute(:name_en,'jewellery')
        end

        it "english" do
          Category.first.names_depth_cache_en.should eq 'jewellery'
        end
        it "persian" do
          Category.first.names_depth_cache_ir.should eq 'jewellery'
        end
      end

      context "its children should be updated for" do
        before(:each) do
          programming = create_category('programming')
          create_category('ruby',programming.id)
          programming.update_attribute(:name_en,'jewellery')
          Category.first.children.map(&:save)
        end

        it "english" do
          Category.last.names_depth_cache_en.should eq 'jewellery/ruby'
        end
        it "persian" do
          Category.last.names_depth_cache_ir.should eq 'jewellery\ruby'
        end
      end

      context "its grand-children should be updated for" do
        before(:each) do
          programming = create_category('programming')
          ruby = create_category('ruby',programming.id)
          create_category('rails',ruby.id)
          programming.update_attribute(:name_en,'jewellery')
          Category.first.descendants.map(&:save)
        end

        it "english" do
          Category.last.names_depth_cache_en.should eq 'jewellery/ruby/rails'
        end

        it "persian" do
          Category.last.names_depth_cache_ir.should eq 'jewellery\ruby\rails'
        end
      end
    end

    context "when changing a parent, #names_depth_cache should be updated for" do
      context "the category in question in" do
        before(:each) do
          programming = create_category('programming')
          religion = create_category('religion')
          programming.update_attributes(:parent_id=>religion.id)
        end

        it "english" do
          Category.first.names_depth_cache_en.should eq 'religion/programming'
        end
        it "persian" do
          Category.first.names_depth_cache_ir.should eq 'religion\programming'
        end
      end

      context "its children for" do
        before(:each) do
          programming = create_category('programming')
          religion = create_category('religion')
          create_category('ruby',programming.id)
          programming.update_attributes(:parent_id=>religion.id)
          programming.descendants.map(&:save)
        end

        it "english" do
          Category.last.names_depth_cache_en.should eq 'religion/programming/ruby'
        end
        it "persian" do
          Category.last.names_depth_cache_ir.should eq 'religion\programming\ruby'
        end
      end
    end
  end
end
