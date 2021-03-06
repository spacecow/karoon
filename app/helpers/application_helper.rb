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
  def concatenate_or_skip(s1,s2,skip=nil)
    return skip if s1.nil?
    return skip if s2.nil?
    s1 + s2
  end
  def class_selection(s)
    #if s.instance_of? Symbol
    #  t(s) == @selection ? "selected" : ''
    #elsif s.instance_of? String
      s == @selection ? "selected" : ''
    #end
  end
  def get_html_language; english? ? :en : :fa end
  def listed_categories(categories)
    return if categories.empty?
    content_tag(:ul,categories.map{|cat,subcat|
      content_tag(:li,link_to(cat.name?(get_language),cat),:class=>class_selection(cat.name?(get_language))) + (subcat.present? ? content_tag(:li,listed_categories(subcat)) : '')
    }.join.html_safe,:class=>'nested_category')
  end

  def present(object,klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object,self)
    yield presenter if block_given?
    presenter
  end

end
