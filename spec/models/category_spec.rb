
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
    before(:each) do
      @programming = create_category('programming')
    end

    context "every time a category gets saved, its path is saved in #names_depth_cache for" do
      it "one category" do
        Category.last.names_depth_cache.should eq 'programming'
      end
      it "two categories" do
        ruby = create_category('ruby',@programming.id)
        Category.last.names_depth_cache.should eq 'programming/ruby'  
      end
    end

    context "if the name of a root category changes, the #names_depth_cache for" do
      it "the root should be changed" do
        @programming.update_attribute(:name,'jewelry')
        Category.first.names_depth_cache.should eq 'jewelry'
      end
      it "its children should be updated" do
        create_category('ruby',@programming.id)
        @programming.update_attribute(:name,'jewelry')
        Category.first.children.map(&:save)
        Category.last.names_depth_cache.should eq 'jewelry/ruby'
      end
      it "its grand-children should be updated" do
        ruby = create_category('ruby',@programming.id)
        create_category('rails',ruby.id)
        @programming.update_attribute(:name,'jewelry')
        Category.first.descendants.map(&:save)
        Category.last.names_depth_cache.should eq 'jewelry/ruby/rails'
      end
    end

    context "when changing a parent, #names_depth_cache should be updated for" do
      it "the category in question" do
        religion = create_category('religion')
        @programming.update_attributes(:parent_id=>religion.id)
        Category.first.names_depth_cache.should eq 'religion/programming'
      end
      it "its children" do
        religion = create_category('religion')
        create_category('ruby',@programming.id)
        @programming.update_attributes(:parent_id=>religion.id)
        @programming.descendants.map(&:save)
        Category.last.names_depth_cache.should eq 'religion/programming/ruby'
      end
    end
  end
end
