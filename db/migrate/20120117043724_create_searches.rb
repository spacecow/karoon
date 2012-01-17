class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :keywords
      t.integer :category_id
      t.integer :user_id
      t.string :ip

      t.timestamps
    end
  end
end
