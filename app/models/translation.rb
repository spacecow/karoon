class Translation < ActiveRecord::Base
  belongs_to :locale

  attr_accessible :key, :value, :locale_token
  attr_reader :locale_token

  validates_presence_of :key,:value,:locale

  def locale_attributes_to_json
    locale.nil? ? '' : [locale.attributes].to_json
  end
  def locale_token=(id)
    if id =~ /^\d+$/
      self.locale_id = id
    elsif id.nil?
    else
      self.locale_id = Locale.find_or_create_by_name(:name=>id).id
    end
  end
end
