class AddBookLinksToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :book_links, :string
  end
end
