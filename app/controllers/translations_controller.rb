class TranslationsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => :index

  def index
    @selection = :translations
    @translation = Translation.new(key: params[:key], value: params[:value])
    @translation.locale = Locale.find_or_create_by_name(params[:locale]) if params[:locale]
    @translations = TRANSLATION_STORE
  end

  def create
    if @translation.valid?
     I18n.backend.store_translations(@translation.locale.name, {@translation.key => @translation.value}, :escape => false)
      redirect_to translations_path
    else
      @translation.errors.add(:locale_token,@translation.errors[:locale]) if @translation.errors[:locale]
      @translations = TRANSLATION_STORE
      render :index
    end
  end

  def update_multiple
    (params[:english]||{}).each do |key,value|
      I18n.backend.store_translations(value[:locale], {value[:key] => value[:value]}, :escape => false) unless value[:value].blank?
    end
    (params[:persian]||{}).each do |key,value|
      I18n.backend.store_translations(value[:locale], {value[:key] => value[:value]}, :escape => false) unless value[:value].blank?
    end
    redirect_to translations_path
  end
end
