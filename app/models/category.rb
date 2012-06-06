class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :books, :through => :categorizations
  has_many :searches
  has_ancestry :orphan_strategy => :rootify
  before_save :cache_ancestry

  attr_accessor :recursion
  attr_accessible :name_en,:name_ir,:parent_id
  validates_uniqueness_of :name_en, :unless => Proc.new{|cat| cat.name_en.blank?}
  validates_uniqueness_of :name_ir, :unless => Proc.new{|cat| cat.name_ir.blank?}
  validates_presence_of :name_en, :if => Proc.new{|cat| cat.name_ir.blank?}
  validates_presence_of :name_ir, :if => Proc.new{|cat| cat.name_en.blank?}
  validate :ancestry_exclude_self

  def cache_ancestry
    self.names_depth_cache_en = ancestors.map{|e| e.name?(:en)}.push(name?(:en)).join('/')
    self.names_depth_cache_ir = ancestors.map{|e| e.name?(:ir)}.push(name?(:ir)).join('\\')
  end

  def english_name
    {id:self.id,name:self.name_en}
  end
  def persian_name
    {id:self.id,name:self.name_ir}
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
    def first_owner; owner.first end
    def last_owner; owner.last end
    def owner; Book end

    def selected_path(search,lang)
      if lang == :en
        where('names_depth_cache_en like ?',"%#{search}%").order(:names_depth_cache_en) 
      else
        where('names_depth_cache_ir like ?',"%#{search}%").order(:names_depth_cache_ir) 
      end
    end
      
    def separate(lang,*cats)
      if lang == :en
        cats.join('/')
      else
        cats.join('\\')
      end
    end

    def token(s,a,lang)
      if s =~ /^\d+$/
        cat = exists?(s) ? find(s) : create("name_#{lang}" => s)
      else
        cat = send("find_or_create_by_name_#{lang}",s)
      end 
      token(a.shift,a,lang).update_attribute(:parent_id,cat) unless a.empty?
      cat
    end
  end

  private

    def ancestry_exclude_self
      errors.add(:parent_id, "cannot be a descendant of itself.") if ancestor_ids.include? self.id
    end 
    def category(s,l) I18n.t(s,:scope=>:categories,:locale=>l) end
end
# == Schema Information
#
# Table name: categories
#
#  id                   :integer(4)      not null, primary key
#  name_ir              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  ancestry             :string(255)
#  names_depth_cache_en :string(255)
#  names_depth_cache_ir :string(255)
#  name_en              :string(255)
#

