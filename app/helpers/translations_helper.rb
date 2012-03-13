module TranslationsHelper
  def key_value(key) key.split('.')[-1] end
  def languages(translations)
    if translations.instance_of? Array
      translations.map{|e| language(e)}.uniq.sort
    else
      languages(translations.keys).sort
    end
  end

  def sorted_unique_suffixes(translations)
    unique_suffixes(translations).sort do |a,b|
      comp = (locale(a) <=> locale(b))
      comp.zero? ? (key_value(a) <=> key_value(b)) : comp
    end
  end

  def switch_language_on_locale(suffix,lang)
    locale(add_language(suffix,lang))
  end

  def translate_or_skip(s,lang,skip=nil)
    TRANSLATION_STORE["#{lang}.#{s}"].nil? ? skip : jt(s,:locale=>lang)
  end

  def unique_suffixes(translations)
    if translations.instance_of? Array
      translations.map{|e| anti_language(e)}.uniq
    else
      unique_suffixes(translations.keys)
    end
  end

  private

    def add_language(suffix,lang) 
      "#{lang}.#{suffix}" 
    end
    def anti_language(s)
      s.split('.')[1..-1].join('.')
    end
    def language(s) s.split('.')[0] end
    def locale(s) s.split('.')[0..-2].join('.') end
end
