module ApplicationHelper
  def anti_language(key)
    key.split('.')[1..-1].join('.')
  end
  def cart_image
    count = current_cart.total_count
    if count > 0
      if count < 10
        image_tag "my_cart_#{count}.png"
      else
        image_tag 'my_cart_9p.png'
      end 
    else
      image_tag 'my_cart_e.png'
    end
  end
  def class_selection(s)
    if s.instance_of? Symbol
      t(s) == @selection ? "selected" : ''
    elsif s.instance_of? String
      s == @selection ? "selected" : ''
    end
  end
  def english?; I18n.locale == :en end
  def key_key(key) key.split('.')[0..-2].join('.') end
  def key_value(key) key.split('.')[-1] end
  def listed_categories(categories)
    return if categories.empty?
    content_tag(:ul,categories.map{|cat,subcat|
      content_tag(:li,link_to(cat.name,cat),:class=>class_selection(cat.name)) + (subcat.present? ? content_tag(:li,listed_categories(subcat)) : '')
    }.join.html_safe,:class=>'nested_category')
  end
  def language(key) key.split('.')[0] end
  def locale(key) key.split('.')[0..-2].join('.') end
  def translate_or_skip(s,lang)
    TRANSLATION_STORE["#{lang}.#{s}"].nil? ? '-' : t(s,:locale=>lang)
  end
end
