class AddAuthorAndCategoryMatchToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :author_match, :string
    add_column :searches, :category_match, :string
  end
end
