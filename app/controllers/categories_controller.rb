class CategoriesController < ApplicationController
  before_filter :load_categories, :only => :index
  load_and_authorize_resource

  def show
  end

  def index
    respond_to do |f|
      f.html
      f.json {render :json => @categories.map(&:attributes)}
    end
  end

  def new
  end
  
  def create
    if @category.save
      redirect_to new_category_path, :notice => created_adv(:category,@category.name)
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @category.update_attributes(params[:category])
      redirect_to @category, :notice => updated_adv(:category,@category.name)
    else
      render :edit
    end
  end

  def destroy
    name = @category.name
    @category.destroy
    redirect_to categories_path, :notice => deleted_adv(:category,name)
  end

  private

    def load_categories
      @categories = Category.where('name like ?',"%#{params[:q]}%").order(:name) 
    end
end
