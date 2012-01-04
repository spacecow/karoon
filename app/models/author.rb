class Author < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :books, :through => :authorships

  def to_s; first_name+" "+last_name end
end
