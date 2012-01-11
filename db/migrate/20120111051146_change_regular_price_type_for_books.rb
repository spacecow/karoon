class ChangeRegularPriceTypeForBooks < ActiveRecord::Migration
  def up
    remove_column :books, :regular_price
    add_column :books, :regular_price, :string
  end

  def down
    remove_column :books, :regular_price
    add_column :books, :regular_price, :integer
  end
end
