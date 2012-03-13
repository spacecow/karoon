class BooksController < ApplicationController
  before_filter :load_books_with_associations, :only => :index
  load_and_authorize_resource

  def show
    if params[:search]
      search = Search.find(params[:search])
      search.add_and_save_book_match(@book.id,@book.title)
    end
  end

  def index
    @site_nav_categories = Category.where(:ancestry => nil)
    @selection = :books
  end

  def new
    @books = [Book.new]
    load_hidden_book(9)
  end

  def create
    if @book.save
      redirect_to new_book_path, :notice => created_adv(:book,@book.title)
    else
      if english?
        @book.errors.add(:category_tokens_en,@book.errors[:categories]) if @book.errors[:categories]
      else
        @book.errors.add(:category_tokens_ir,@book.errors[:categories]) if @book.errors[:categories]
      end 
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
    @books.reject!(&:all_fields_empty?)
    if @books.empty? #no temporary filled fields 
      if i == 0 #no fields filled in
        @books << Book.new
        @books.map(&:save)
        load_hidden_book(9)
        flash.now[:alert] = not_created(:book)
        render :new
      else #i fully filled fields
        redirect_to new_book_path, :notice => created(:book,i)
      end
    else #temporary filled fields
      if currency_in_riel?
        @books.map! do |book|
          book.convert_to_riel; book
        end 
      end
      if i == 0 #no fully filled fields
        flash.now[:alert] = not_created(:book)
      else
        flash.now[:notice] = created(:book,i)
      end
      load_hidden_book(10-@books.count)
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
      if english?
        @book.errors.add(:category_tokens_en,@book.errors[:categories]) if @book.errors[:categories]
      else
        @book.errors.add(:category_tokens_ir,@book.errors[:categories]) if @book.errors[:categories]
      end 
      @book.convert_to_riel if currency_in_riel?
      render :edit
    end
  end

  def destroy
    title = @book.title
    @book.destroy
    redirect_to books_path, :notice => deleted_adv(:book,title)
  end

  def who_bought
    respond_to do |f|
      f.atom
    end
  end

  private

    def load_books_with_associations
      @books = Book.includes(:categories,:authors).page(params[:page]).per_page(1)
    end
    def load_hidden_book(i)
      i.times do
        book = Book.new
        book.hide = true
        @books << book
      end
    end
end
