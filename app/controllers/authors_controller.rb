class AuthorsController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def index
    @authors = Author.where('name like ?',"%#{params[:q]}%").sort_by(&:last_name)
    respond_to do |f|
      f.html
      f.json {render :json => @authors.map(&:attributes)}
    end
  end

  def new
  end

  def create
    if @author.save
      flash[:notice] = created_adv(:author,@author.name)
      redirect_to new_author_path
    end
  end

  def edit
  end

  def update
    if @author.update_attributes(params[:author])
      redirect_to @author, :notice => updated_adv(:author,@author.name)
    end
  end

  def destroy
    name = @author.name
    @author.destroy
    redirect_to authors_path, :notice => deleted_adv(:author,name)
  end
end
