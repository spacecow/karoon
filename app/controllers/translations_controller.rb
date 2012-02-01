class TranslationsController < ApplicationController
  load_and_authorize_resource

  def index
    @selection = t(:translations)
    @translation = Translation.new
  end

  def create
    if @translation.save
      redirect_to translations_path
    else
      render :index
    end
  end
end
