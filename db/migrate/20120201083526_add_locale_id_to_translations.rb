class AddLocaleIdToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :locale_id, :integer
  end
end
