class AddParentToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry
    add_column :categories, :names_depth_cache, :string
  end

  def self.down
    remove_index :categories, :ancestry
    remove_column :categories, :ancestry
    remove_column :categories, :names_depth_cache 
  end
end
