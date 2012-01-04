class Book < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships
  accepts_nested_attributes_for :authorships

  attr_reader :author_tokens
  attr_accessible :title,:author_tokens

  validates_presence_of :title

  def author; authors.first == authors.last ? authors.first : nil end

  def author_tokens=(ids)
    self.author_ids = ids.split(',')
  end
end
