class AddBookLinksToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :book_match, :string
  end
end
