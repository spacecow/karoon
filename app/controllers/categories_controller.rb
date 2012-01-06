class CategoriesController < ApplicationController
  before_filter :load_categories, :only => :index
  load_and_authorize_resource

  def show
  end

  def index
    respond_to do |f|
      f.html
      f.json {render :json => @categories.map{|e| e.name=e.names_depth_cache; e}.map(&:attributes)}
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
    @categories = Category.all
  end
  
  def update
    if @category.update_attributes(params[:category])
      @category.descendants.map(&:save) #update names_depth_cache
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
      @categories = Category.where('names_depth_cache like ?',"%#{params[:q]}%").order(:names_depth_cache) 
    end
end
