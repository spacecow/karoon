class AddItemPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :price, :string
  end
end
