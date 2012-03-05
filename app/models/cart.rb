class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  accepts_nested_attributes_for :line_items

  def add_book(hash)
    current_item = line_items.find_by_book_id(hash[:book_id])
    if current_item
      current_item.quantity += hash[:quantity].to_i
    else
      current_item = line_items.build(hash)
    end
    current_item
  end

  def total_count
    line_items.to_a.sum(&:quantity)
  end
  def total_price(riel)
    line_items.to_a.sum{|e| e.total_price(riel)} 
  end
end
# == Schema Information
#
# Table name: carts
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

