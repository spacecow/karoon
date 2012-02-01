class LocalesController < ApplicationController
  load_and_authorize_resource
  
  def index
    respond_to do |f|
      f.html
      f.json {render :json => @locales.map(&:attributes)}
    end
  end
end
