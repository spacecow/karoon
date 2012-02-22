class Categorization < ActiveRecord::Base
  belongs_to :book
  belongs_to :category

  class << self
    def first_owner; first.book end
    def last_owner; last.book end
  end
end
