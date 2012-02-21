class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_filter :load_all_categories, :only => :new
  before_filter :load_min_categories, :only => :edit


  def show
    if params[:search]
      search = Search.find(params[:search])
      search.add_and_save_category_match(@category.id,@category.name(get_language))
    end
    if @category.parent
      @site_nav_categories = @category.ancestors.arrange(:order => :names_depth_cache_en)
      hash = ActiveSupport::OrderedHash.new
      hash[@category] = @category.children.arrange(:order => :names_depth_cache_en)
      attach_children(@site_nav_categories,hash)
    else
      @site_nav_categories = ActiveSupport::OrderedHash.new
      @site_nav_categories[@category] = @category.children.arrange(:order => :names_depth_cache_en)
    end
      
    @selection = @category.name(get_language)
  end

  def index
    if params[:id] 
      @category = Category.find(params[:id]) 
      @categories = Category.where(["id NOT IN (?)",@category.subtree_ids])
    else
      @category = Category.new
      @categories = Category.scoped
    end
    @category_hash = Category.scoped.arrange(:order => :names_depth_cache_en)

    @selection = :categories
    respond_to do |f|
      f.html
      f.json {render :json => load_selected_categories.map{|e| e.name=e.names_depth_cache_en; e}.map(&:attributes)}
    end
  end

  def create
    if @category.save
      redirect_to categories_path, :notice => created(:category)
    else
      #load_all_categories
      @categories = Category.scoped
      @category_hash = @categories.arrange(:order => :names_depth_cache_en)
      render :index
    end
  end

  def update
    if @category.update_attributes(params[:category])
      @category.descendants.map(&:save) #update names_depth_cache
      redirect_to categories_path, :notice => updated(:category)
    else
      #load_min_categories
      @categories = Category.where(["id NOT IN (?)",@category.subtree_ids])
      @category_hash = Category.scoped.arrange(:order => :names_depth_cache_en)
      render :index
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, :notice => deleted(:category)
  end

  private

    def attach_children(hash,value)
      hash.each do |k,v|
        if v.empty? 
          hash[k] = value 
        else
          attach_children(hash[k],value)
        end 
      end
    end
    def load_all_categories
      @categories = Category.all.map{|e| [e.names_depth_cache_en,e.id]}
    end
    def load_min_categories
      @categories = Category.all.reject{|e| @category.subtree_ids.include? e.id}.map{|e| [e.names_depth_cache_en,e.id]}
    end
    def load_selected_categories
      @categories = Category.where('names_depth_cache_en like ?',"%#{params[:q]}%").order(:names_depth_cache_en) 
    end
end
