class Translation < ActiveRecord::Base
  belongs_to :locale

  attr_accessible :key, :value, :locale_token
  attr_reader :locale_token

  validates_presence_of :key,:value,:locale

  def anti_language
    full_key.split('.')[1..-1].join('.') if locale
  end
  def full_key
    "#{locale.name}.#{key}" if locale
  end
  def locale_attributes_to_json
    locale.nil? ? '' : [locale.attributes].to_json
  end
  def locale_token
    self.locale_token = locale.name if locale 
  end
  def locale_token=(id)
    if id =~ /^\d+$/
      self.locale_id = id
    elsif id.nil?
    else
      self.locale_id = Locale.find_or_create_by_name(:name=>id).id
    end
  end

  class << self 
    def generate_keys(file)
      set = Set.new
      File.open(file,File::RDONLY) do |f|
        index = 0
        f.each do |line|
          set.add(line)
        end
      end
      File.open('data/unique_translation_keys.txt',File::WRONLY) do |f|
        f.puts set.to_a.sort
      end
    end
  end
end
