class RenameTitleToNameInLocales < ActiveRecord::Migration
  def change 
    rename_column :locales, :title, :name
  end
end
