class AddFieldsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :regular_price, :integer
    add_column :books, :summary, :text
  end
end
