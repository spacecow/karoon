class BooksController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @book.authorships.build
    @authors = Author.all
  end

  def create
    if @book.save
      redirect_to books_path, :notice => created(:book)
    else
      render :new
    end
  end
end
