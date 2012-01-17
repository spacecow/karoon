class SearchesController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def create
    @search.ip = request.remote_ip
    @search.user = current_user if current_user
    if @search.save
      if @search.keywords.blank?
        redirect_to @search.category and return if @search.category 
        redirect_to books_path
      else
        redirect_to @search
      end
    end
  end
end
