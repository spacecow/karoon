module BooksHelper
  def link_to_authors(authors)
    authors.map do |author|
      link_to author.name, author
    end.join(', ').html_safe
  end
  def link_to_categories(categories)
    categories.map do |category|
      link_to category.names_depth_cache, category
    end.join(', ').html_safe
  end
  def search_link_to(lbl,path,obj)
    link_to lbl,send(path,obj,(@search ? {:search=>@search.id} : nil)) 
  end
end
