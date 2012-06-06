class Book < ActiveRecord::Base
  has_many :line_items
  has_many :orders, :through => :line_items
  belongs_to :user
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships
  has_many :categorizations, :dependent => :destroy
  has_many :categories, :through => :categorizations

  attr_reader :author_tokens, :category_tokens_en, :category_tokens_ir
  attr_accessible :title,:author_tokens,:category_tokens_en,:category_tokens_ir,:image, :image_cache, :summary,:regular_price
  attr_accessor :hide

  before_destroy :ensure_not_referenced_by_any_line_item

  validates_presence_of :title,:regular_price,:categories
  validates_uniqueness_of :title
  validates_numericality_of :regular_price, :unless => :errors_on_regular_price?
  validate :lowest_price

  mount_uploader :image, ImageUploader

  def all_fields_empty?
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
  def authors_count; authors.count end

  def categories_count; categories.count end
  def category
    categories.first == categories.last ? categories.first : nil 
  end
  def category_tokens_en=(s)
    tokens = []
    s.split(',').map(&:strip).each do |cat|
      tokens.push treed_category_tokens(cat,:en) 
    end
    self.category_ids = tokens 
  end
  def category_tokens_ir=(s)
    tokens = []
    s.split(',').map(&:strip).each do |cat|
      tokens.push treed_category_tokens(cat,:ir) 
    end
    self.category_ids = tokens 
  end

  def price(riel)
    riel ? regular_price.to_i*10 : regular_price.to_i
  end

  def regular_price_in_riel
    regular_price =~ /^\d+$/ ? regular_price.to_i*10 : regular_price
  end

  def convert_to_riel
    self.regular_price = regular_price_in_riel
    errors[:regular_price].map! do |err|
      err.gsub(/50/,'500') 
    end 
  end

  private

    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base,'Line Item present')
        return false
      end
    end
    def errors_on_regular_price?
      errors[:regular_price].present?
    end
    def lowest_price
      if regular_price
        error = I18n.t('activerecord.errors.messages.greater_than',:count => 50) if regular_price.to_i < 50 
        errors.add(:regular_price,error) if error && !errors_on_regular_price?
      end
    end

    def treed_category_tokens(s,lang)
      if lang == :en
        a = s.split('/')
      else
        a = s.split('\\')
      end
      cat = Category.token(a.shift,a,lang)
      cat.id
    end
end
# == Schema Information
#
# Table name: books
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  image         :string(255)
#  summary       :text
#  user_id       :integer(4)
#  regular_price :string(255)
#

