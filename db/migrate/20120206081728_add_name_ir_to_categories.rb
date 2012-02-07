class AddNameIrToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :names_depth_cache_ir, :string
    rename_column :categories, :names_depth_cache, :names_depth_cache_en
  end
end
