class Book < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships
  accepts_nested_attributes_for :authorships

  attr_accessible :title,:authorships_attributes

  validates_presence_of :title

  def author; authors.first == authors.last ? authors.first : nil end
end
