class Book < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships
  has_many :categorizations, :dependent => :destroy
  has_many :categories, :through => :categorizations

  attr_reader :author_tokens
  attr_reader :category_tokens
  attr_accessible :title,:author_tokens,:category_tokens,:image,:summary,:regular_price

  validates_presence_of :title,:regular_price,:categories
  validate :lowest_price

  mount_uploader :image, ImageUploader

  def author
    authors.first == authors.last ? authors.first : nil 
  end
  def author_tokens=(ids)
    tokens = []
    ids.split(',').map(&:strip).each do |id|
      if id =~ /^\d+$/
        tokens.push id
      else
        tokens.push Author.create!(:name=>id).id
      end
    end
    self.author_ids = tokens
  end

  def category
    categories.first == categories.last ? categories.first : nil 
  end
  def category_tokens=(ids)
    tokens = []
    ids.split(',').map(&:strip).each do |id|
      if id =~ /^\d+$/
        tokens.push id
      else
        tokens.push Category.create!(:name=>id).id
      end
    end
    self.category_ids = tokens
  end
  def regular_price=(i)
    i = i.to_i / 10 if Setting.currency_in_riel?
    write_attribute(:regular_price,i) 
  end

  private

    def lowest_price
      errors.add(:regular_price,I18n.t('activerecord.errors.messages.greater_than',:count => 50)) if regular_price && regular_price < 50
    end
end
