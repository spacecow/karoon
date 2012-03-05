class Categorization < ActiveRecord::Base
  belongs_to :book
  belongs_to :category

  class << self
    def first_owner; first.book end
    def last_owner; last.book end
  end
end
# == Schema Information
#
# Table name: categorizations
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  book_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

