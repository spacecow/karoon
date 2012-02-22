class AddNameEnToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :name_en, :string
    rename_column :categories, :name, :name_ir
  end
end
