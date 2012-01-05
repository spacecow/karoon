class Author < ActiveRecord::Base
  has_many :authorships, :dependent => :destroy
  has_many :books, :through => :authorships

  attr_reader :first_name,:middle_names
  def to_s; name end

  def first_name; self.name && self.name.split[0] end
  def first_name=(s); self.name = s.strip end
  def middle_names
    self.name && self.name.split[1..-2].join(' ')
  end
  def middle_names=(s); self.name += " "+s.strip end
  def last_name; self.name && self.name.split[-1] end
  def last_name=(s); self.name += " "+s.strip end
end
