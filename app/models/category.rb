class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :books, :through => :categorizations
  has_many :searches
  has_ancestry :orphan_strategy => :rootify
  before_save :cache_ancestry

  attr_accessor :recursion
  attr_accessible :name,:parent_id
  validates :name, :presence => true, :uniqueness => true
  validate :ancestry_exclude_self

  def cache_ancestry
    #jp ancestors = ancestors.map(&:name)
    #ancestors.pop unless new_record?
    self.names_depth_cache = ancestors.map(&:name).push(name).join('/')
  end
  
  private

    def ancestry_exclude_self
      errors.add(:parent_id, "cannot be a descendant of itself.") if ancestor_ids.include? self.id
    end 
end
