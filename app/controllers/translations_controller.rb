class TranslationsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => :index

  def index
    @selection = t(:translations)
    @translation = Translation.new
    @translations = TRANSLATION_STORE
  end

  def create
    if @translation.valid?
     I18n.backend.store_translations(@translation.locale.name, {@translation.key => @translation.value}, :escape => false)
      # save to redis
      redirect_to translations_path
    else
      @translation.errors.add(:locale_token,@translation.errors[:locale]) if @translation.errors[:locale]
      @translations = TRANSLATION_STORE
      render :index
    end
  end
end
