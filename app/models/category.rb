class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :books, :through => :categorizations
  has_many :searches
  has_ancestry :orphan_strategy => :rootify
  before_save :cache_ancestry

  attr_accessor :recursion
  attr_accessible :name_en,:parent_id
  validates_uniqueness_of :name_en, :name_ir
  validates_presence_of :name_en, :if => Proc.new{|cat| cat.name_ir.blank?}
  validates_presence_of :name_ir, :if => Proc.new{|cat| cat.name_en.blank?}
  validate :ancestry_exclude_self

  def cache_ancestry
    self.names_depth_cache_en = ancestors.map{|e| e.name?(:en)}.push(name?(:en)).join('/')
    self.names_depth_cache_ir = ancestors.map{|e| e.name?(:ir)}.push(name?(:ir)).join('\\')
  end

  def name(lang) send("name_#{lang}") end
  def name?(lang) 
    if lang==:en
      name_en.present? ? name_en : name_ir
    else
      name_ir.present? ? name_ir : name_en
    end
  end

  def translated_name(lang)
    send("name_#{lang}")
    #category(name,lang) 
  end
  def names_depth_cache(lang)
    #names_depth_cache_en.split('/').map{|e| category(e)}.join('/')
    lang==:en ? names_depth_cache_en : names_depth_cache_ir
  end
  
  class << self
    def separate(lang,*cats)
      if lang == :en
        cats.join('/')
      else
        cats.join('\\')
      end
    end
  end

  private

    def ancestry_exclude_self
      errors.add(:parent_id, "cannot be a descendant of itself.") if ancestor_ids.include? self.id
    end 
    def category(s,l) I18n.t(s,:scope=>:categories,:locale=>l) end
end
