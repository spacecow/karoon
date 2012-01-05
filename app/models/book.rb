class Book < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :authors, :through => :authorships
  accepts_nested_attributes_for :authorships

  attr_reader :author_tokens
  attr_accessible :title,:author_tokens

  validates_presence_of :title

  def author; authors.first == authors.last ? authors.first : nil end

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
end
