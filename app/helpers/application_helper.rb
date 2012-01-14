module ApplicationHelper
  def class_selection(s)
    if s.instance_of? Symbol
      t(s) == @selection ? "class='selected'" : ''
    elsif s.instance_of? String
      s == @selection ? "class='selected'" : ''
    end
  end
end
