class Search < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :keywords,:category_id
end
