class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :books, :through => :categorizations
  has_many :searches
  has_ancestry :orphan_strategy => :rootify
  before_save :cache_ancestry

  attr_accessor :recursion
  attr_accessible :name,:parent_id
  validates :name, :presence => true, :uniqueness => true
  validates_format_of :name, :with => /^[a-zA-Z0-9_]+$/
  validate :ancestry_exclude_self

  def cache_ancestry
    #jp ancestors = ancestors.map(&:name)
    #ancestors.pop unless new_record?
    self.names_depth_cache_en = ancestors.map{|e| category(e.name,:en)}.push(category(name,:en)).join('/')
    self.names_depth_cache_ir = ancestors.map{|e| category(e.name,:ir)}.push(category(name,:ir)).join('\\')
  end

  def translated_name(lang); category(name,lang) end
  def names_depth_cache(lang)
    #names_depth_cache_en.split('/').map{|e| category(e)}.join('/')
    lang==:en ? names_depth_cache_en : names_depth_cache_ir
  end
  
  private

    def ancestry_exclude_self
      errors.add(:parent_id, "cannot be a descendant of itself.") if ancestor_ids.include? self.id
    end 
    def category(s,l) I18n.t(s,:scope=>:categories,:locale=>l) end
end
