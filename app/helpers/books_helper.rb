module BooksHelper
  def link_to_authors(authors)
    authors.map do |author|
      search_link_to author.name, :author_path, author
    end.join(', ').html_safe
  end
  def link_to_categories(categories)
    categories.map do |category|
      search_link_to category.names_depth_cache, :category_path, category
    end.join(', ').html_safe
  end
  def search_link_to(lbl,path,obj)
    link_to lbl,send(path,obj,(@search ? {:search=>@search.id} : nil)) 
  end
end
