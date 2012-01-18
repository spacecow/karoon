class BooksController < ApplicationController
  before_filter :load_books_with_associations, :only => :index
  load_and_authorize_resource

  def index
    @site_nav_categories = Category.where(:ancestry => nil)
    @selection = t(:books)
  end

  def new
    @books = [Book.new]
    load_hidden_book(9)
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
    if currency_in_riel?
      params[:books].each do |k,v|
        val = params[:books][k]["regular_price"]
        params[:books][k]["regular_price"] = val.to_i/10 if val =~ /^\d+$/
      end
    end
    @books = Book.create(params[:books].values).reject{|e| e.errors.empty?} 
    i = params[:books].count - @books.count
    @books.reject!(&:all_fields_emtpy?)
    if @books.empty? 
      if i == 0
        @books << Book.new
        @books.map(&:save)
        load_hidden_book(9)
        flash[:alert] = not_created(:book)
        render :new
      else
        redirect_to new_book_path, :notice => created(:book,i,:books)
      end
    else
      if currency_in_riel?
        @books.map! do |book|
          book.convert_to_riel; book
        end 
      end
      load_hidden_book(10-@books.count)
      flash[:notice] = created(:book,i,:books)
      render :new
    end
  end

  def edit
    if currency_in_riel?
      @book.regular_price = @book.regular_price_in_riel
    end
  end

  def update
    if currency_in_riel?
      val = params[:book]["regular_price"]
      params[:book]["regular_price"] = (val.to_i/10).to_s if val =~ /^\d+$/
    end
    if @book.update_attributes(params[:book])
      redirect_to @book, :notice => updated_adv(:book,@book.title)
    else
      @book.errors.add(:category_tokens,@book.errors[:categories]) if @book.errors[:categories]
      @book.convert_to_riel if currency_in_riel?
      render :edit
    end
  end

  def destroy
    title = @book.title
    @book.destroy
    redirect_to books_path, :notice => deleted_adv(:book,title)
  end

  private

    def load_books_with_associations
      @books = Book.includes(:categories,:authors)
    end
    def load_hidden_book(i)
      i.times do
        book = Book.new
        book.hide = true
        @books << book
      end
    end
end
