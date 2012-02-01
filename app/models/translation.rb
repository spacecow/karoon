class Translation < ActiveRecord::Base
  attr_accessible :key, :value

  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
end
