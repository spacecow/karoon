class TranslationsController < ApplicationController
  def index
    @selection = t(:translations)
    @translation = Translation.new
  end
end
