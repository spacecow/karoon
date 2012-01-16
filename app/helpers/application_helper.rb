module ApplicationHelper
  def class_selection(s)
    if s.instance_of? Symbol
      t(s) == @selection ? "class='selected'" : ''
    elsif s.instance_of? String
      s == @selection ? "class='selected'" : ''
    end
  end
  def listed_categories(categories)
    return if categories.empty?
    content_tag(:ul,categories.map{|cat,subcat|
      content_tag(:li,link_to(cat.name,cat)) + (subcat.present? ? content_tag(:li,listed_categories(subcat)) : '')
    }.join.html_safe)
  end
end
