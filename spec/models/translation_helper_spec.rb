require 'spec_helper'
require 'translation_helper'

describe TranslationHelper do
  before(:each) do
    @obj = Object.new    
    @obj.extend(TranslationHelper)
  end

  context "#sorted_unique_suffixes" do
    it "returns an empty array" do
      @obj.sorted_unique_suffixes([]).should be_empty
    end

    it "returns an array with one element" do
      @obj.sorted_unique_suffixes(['en.book']).should eq ['book'] 
    end

    it "sort elements with two segments" do
      @obj.sorted_unique_suffixes(['en.book','en.author']).should eq %w(author book) 
    end

    it "sort two and three segments" do
      @obj.sorted_unique_suffixes(['en.book','en.authors.kevin']).should eq %w(book authors.kevin) 
    end
  end

  context "#unique_suffixes" do
    it "returns an array from a hash" do
      @obj.unique_suffixes({'en.book'=>'Book'}).should eq ['book']
    end
    it "returns an array from an array " do
      @obj.unique_suffixes(['en.book']).should eq ['book']
    end

    it "don't return duplicates" do
      @obj.unique_suffixes(['en.book','ir.book']).should eq ['book']
    end 
  end

  context "#anti_language" do
    it "drop language for a double segment" do
      @obj.send(:anti_language,'en.book').should eq 'book'
    end
    it "drop language for a double segment" do
      @obj.send(:anti_language,'en.labels.new').should eq 'labels.new'
    end
  end

  context "#languages" do
    it "returns an array of languages" do
      @obj.languages(['en.book','ir.author']).should eq %w(en ir)
    end
    it "does not return duplicates" do
      @obj.languages(['en.book','en.author']).should eq %w(en)
    end
  end

  context "#language" do
    it "returns the language" do
      @obj.send('language','en.book').should eq 'en'
    end
  end

  context "#add_language" do
    it "adds language to suffix" do
      @obj.send('add_language','book','en').should eq 'en.book'
    end
  end
  context "#locale" do

    it "returns the locale" do
      @obj.send('locale','en.labels.add').should eq 'en.labels'
    end
  end
end
