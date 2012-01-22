class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy

  def add_book(hash)
    current_item = line_items.find_by_book_id(hash[:book_id])
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(hash)
    end
    current_item
  end

  def price(riel)
    line_items.to_a.sum{|e| e.price(riel)} 
  end
end
