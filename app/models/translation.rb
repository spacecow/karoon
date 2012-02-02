class Translation < ActiveRecord::Base
  belongs_to :locale

  attr_accessible :key, :value, :locale_token
  attr_reader :locale_token

  validates_presence_of :key,:value,:locale

  def locale_token=(id)
    if id =~ /^\d+$/
      self.locale_id = id
    elsif id.empty?
    else
      self.locale_id = Locale.create!(:name=>id).id
    end
  end
end
