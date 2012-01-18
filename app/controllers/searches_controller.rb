class SearchesController < ApplicationController
  load_and_authorize_resource

  def show
    @new_search.keywords = @search ? @search.keywords : nil 
    @new_search.category_id = @search ? @search.category_id : nil
  end

  def create
    if @search.keywords.blank?
      redirect_to @search.category and return if @search.category 
      redirect_to books_path and return
    end
    @search.ip = request.remote_ip
    @search.user = current_user if current_user
    if @search.save
      redirect_to @search
    end
  end
end
