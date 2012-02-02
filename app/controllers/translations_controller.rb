class TranslationsController < ApplicationController
  load_and_authorize_resource

  def index
    @selection = t(:translations)
    @translation = Translation.new
  end

  def create
    if @translation.valid?
     I18n.backend.store_translations(@translation.locale.name, {@translation.key => @translation.value}, :escape => false)
      # save to redis
      redirect_to translations_path
    else
      @translation.errors.add(:locale_token,@translation.errors[:locale]) if @translation.errors[:locale]
      render :index
    end
  end
end
