class Search < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :keywords,:category_id

  def books
    @books = Book.scoped 
    @books = @books.includes(:categories).where("categories.id = ?",category_id) if category_id
    @books = @books.where("title LIKE ?","%#{keywords}%")
  end
end
