class Locale < ActiveRecord::Base
  has_many :translations
  
  validates :name, presence:true
end
# == Schema Information
#
# Table name: locales
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

