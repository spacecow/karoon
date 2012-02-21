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
      #if @translation.locale.name =~ /\w\w\.categories/
      #  category = Category.find_by_name(@translation.key)
      #  if category #update names_depth_cache 
      #    category.save
      #    category.descendants.map(&:save) 
      #  end
      #end
      redirect_to translations_path
    else
      @translation.errors.add(:locale_token,@translation.errors[:locale]) if @translation.errors[:locale]
      @translations = TRANSLATION_STORE
      render :index
    end
  end

  def update_multiple
    (params[:en]||{}).each do |key,value|
      I18n.backend.store_translations(value[:locale], {value[:key] => value[:value]}, :escape => false) unless value[:value].blank?
      #if value[:locale] == 'en.categories'
      #  category = Category.find_by_name(value[:key])
      #  if category #update names_depth_cache 
      #    category.save
      #    category.descendants.map(&:save) 
      #  end
      #end
    end
    (params[:ir]||{}).each do |key,value|
      I18n.backend.store_translations(value[:locale], {value[:key] => value[:value]}, :escape => false) unless value[:value].blank?
      #if value[:locale] == 'ir.categories'
      #  category = Category.find_by_name(value[:key])
      #  if category #update names_depth_cache 
      #    category.save
      #    category.descendants.map(&:save) 
      #  end
      #end
    end
    redirect_to translations_path
  end
end
