class Search < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :keywords,:category_id

  def add_and_save_book_link(id,title)
    add_book_link(id,title)
    save
  end
  def add_book_link(id,title)
    if self.book_links.nil?
      arr = [id,title]
    else 
      arr = eval(self.book_links)
      arr.push id
      arr.push title
    end
    self.book_links = arr.to_json
  end

  def books
    @books = Book.scoped 
    @books = @books.includes(:categories).where("categories.id = ?",category_id) if category_id
    @books = @books.where("title LIKE ?","%#{keywords}%")
  end
end
