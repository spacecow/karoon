class Book < ActiveRecord::Base
  belongs_to :user
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships
  has_many :categorizations, :dependent => :destroy
  has_many :categories, :through => :categorizations

  attr_reader :author_tokens
  attr_reader :category_tokens
  attr_accessible :title,:author_tokens,:category_tokens,:image,:summary,:regular_price

  validates_presence_of :title,:regular_price,:categories
  validates_uniqueness_of :title
  validates_numericality_of :regular_price, :unless => :errors_on_regular_price?
  validate :lowest_price

  mount_uploader :image, ImageUploader

  def all_fields_emtpy?
    title.blank? && summary.blank? && regular_price.blank? && image.blank? && authors.empty? && categories.empty?
  end

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
        tokens.push Category.create(:name=>id).id end
    end
    self.category_ids = tokens
  end
  def regular_price=(i)
    i = i.to_i / 10 if Setting.currency_in_riel? && i =~ /^\d+$/
    write_attribute(:regular_price,i) 
  end

  private

    def errors_on_regular_price?
      errors[:regular_price].present?
    end
    def lowest_price
      if regular_price
        if Setting.currency_in_riel?
          error = I18n.t('activerecord.errors.messages.greater_than',:count => 500) if regular_price.to_i < 500 
        elsif Setting.currency_in_toman?
          error = I18n.t('activerecord.errors.messages.greater_than',:count => 50) if regular_price.to_i < 50 
        end
        errors.add(:regular_price,error) if error && !errors_on_regular_price?
      end
    end
end
