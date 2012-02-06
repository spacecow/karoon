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
    self.names_depth_cache = ancestors.map(&:name).push(name).join('/')
  end

  def translated_name; category(name) end
  def translated_names_depth_cache
    names_depth_cache.split('/').map{|e| category(e)}.join('/')
  end
  
  private

    def ancestry_exclude_self
      errors.add(:parent_id, "cannot be a descendant of itself.") if ancestor_ids.include? self.id
    end 
    def category(s) I18n.t(s,:scope=>:categories) end
end
