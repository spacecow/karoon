class SettingsController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if @setting.update_attributes(params[:setting])
      redirect_to edit_setting_path(@setting), :notice => updated(:settings)
    end
  end
end
