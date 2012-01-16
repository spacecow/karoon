module ApplicationHelper
  def class_selection(s)
    if s.instance_of? Symbol
      t(s) == @selection ? "selected" : ''
    elsif s.instance_of? String
      s == @selection ? "selected" : ''
    end
  end
  def listed_categories(categories)
    return if categories.empty?
    content_tag(:ul,categories.map{|cat,subcat|
      content_tag(:li,link_to(cat.name,cat),:class=>class_selection(cat.name)) + (subcat.present? ? content_tag(:li,listed_categories(subcat)) : '')
    }.join.html_safe,:class=>'nested_category')
  end
end
