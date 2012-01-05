class BooksController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @book.authorships.build
    @authors = Author.all
    @author = Author.new
  end

  def create
    if @book.save
      redirect_to new_book_path, :notice => created_adv(:book,@book.title)
    else
      @author = Author.new
      render :new
    end
  end

  def edit
    @author = Author.new
  end

  def update
    if @book.update_attributes(params[:book])
      redirect_to @book, :notice => updated_adv(:book,@book.title)
    else
      @author = Author.new
      render :edit
    end
  end

  def destroy
    title = @book.title
    @book.destroy
    redirect_to books_path, :notice => deleted_adv(:book,title)
  end
end
