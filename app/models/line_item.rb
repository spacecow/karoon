class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :cart
end
