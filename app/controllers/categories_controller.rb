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
      flash[:notice] = created_adv(:category,@category.name)
      redirect_to new_category_path
    else
      render :new
    end
  end

  private

    def load_categories
      @categories = Category.order(:name) 
    end
end
