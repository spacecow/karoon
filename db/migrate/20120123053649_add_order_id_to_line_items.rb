class AddOrderIdToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :order_id, :integer
    remove_column :line_items, :user_id
  end

  def self.down
    remove_column :line_items, :order_id
    add_column :line_items, :user_id, :integer
  end
end
