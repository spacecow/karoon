class BooksController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @books = [Book.new]
    9.times do
      book = Book.new
      book.hide = true
      @books << book
    end
  end

  def create
    if @book.save
      redirect_to new_book_path, :notice => created_adv(:book,@book.title)
    else
      @book.errors.add(:category_tokens,@book.errors[:categories]) if @book.errors[:categories]
      render :new
    end
  end

  def create_individual
    @books = Book.create(params[:books].values).reject{|e| e.errors.empty?} 
    i = params[:books].count - @books.count
    @books.reject!(&:all_fields_emtpy?)
    if @books.empty? 
      if i == 0
        @books << Book.new
        @books.map(&:save)
        9.times do
          book = Book.new
          book.hide = true
          @books << book
        end
        flash[:alert] = not_created(:book)
        render :new
      else
        redirect_to new_book_path, :notice => created(:book,i,:books)
      end
    else
      @books.map!{|e| e.regular_price = e.regular_price_in_riel; e}
      (10-@books.count).times do
        book = Book.new
        book.hide = true
        @books << book
      end
      render :new, :notice => created(:book,i,:books)
    end
  end

  def edit
    @book.regular_price = @book.regular_price_in_riel
  end

  def update
    if @book.update_attributes(params[:book])
      redirect_to @book, :notice => updated_adv(:book,@book.title)
    else
      @book.errors.add(:category_tokens,@book.errors[:categories]) if @book.errors[:categories]
      @book.regular_price = @book.regular_price_in_riel
      render :edit
    end
  end

  def destroy
    title = @book.title
    @book.destroy
    redirect_to books_path, :notice => deleted_adv(:book,title)
  end
end
