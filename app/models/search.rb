class Search < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :keywords,:category_id

  validates_presence_of :keywords, :ip

  def add_and_save_author_match(id,name)
    add_and_save_match(:author,id,name)
  end
  def add_and_save_book_match(id,title)
    add_and_save_match(:book,id,title)
  end
  def add_and_save_category_match(id,name)
    add_and_save_match(:category,id,name)
  end

  def books
    @books = Book.scoped 
    @books = @books.includes(:categories).where("categories.id = ?",category_id) if category_id
    @books = @books.where("title LIKE ?","%#{keywords}%")
  end

  private

    def add_and_save_match(assoc,id,text)
      add_match(assoc,id,text)
      save
    end

    def add_match(assoc,id,text)
      if send("#{assoc}_match".to_sym).nil?
        arr = [id,text]
      else 
        arr = eval(send("#{assoc}_match".to_sym))
        arr.push id
        arr.push text
      end
      send("#{assoc}_match=".to_sym,arr.to_json)
    end
end
