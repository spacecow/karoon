class AddPostalServiceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :postal_service, :string
  end
end
