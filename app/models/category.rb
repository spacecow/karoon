class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :books, :through => :categorizations

  attr_accessible :name
  validates :name, :presence => true, :uniqueness => true
end
