require 'enumerator'

module SearchesHelper
  def link_author_json_array(json_arr)
    link_json_array(json_arr,:author_path)
  end
  def link_book_json_array(json_arr)
    link_json_array(json_arr,:book_path)
  end
  def link_category_json_array(json_arr)
    link_json_array(json_arr,:category_path)
  end
  def link_json_array(json_arr,path)
    arr = eval(json_arr)
    ret = []
    arr.each_slice(2) do |id,text|
      ret.push(link_to(text,send(path,id)))
    end
    ret.join(', ').html_safe
  end
end
