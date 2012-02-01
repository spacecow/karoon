class Locale < ActiveRecord::Base
  has_many :translations
  
  validates :name, presence: true
end
