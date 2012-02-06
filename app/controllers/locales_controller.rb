class LocalesController < ApplicationController
  skip_load_resource :only => :index
  load_and_authorize_resource
  
  def index
    @locales = Locale.where('name like ?',"%#{params[:q]}%")
    respond_to do |f|
      f.html
      f.json {render :json => @locales.map(&:attributes)}
    end
  end
end
