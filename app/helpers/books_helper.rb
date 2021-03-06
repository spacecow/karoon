module BooksHelper
  def link_to_authors(authors)
    authors.map do |author|
      search_link_to author.name, :author_path, author
    end.join(', ').html_safe
  end
  def link_to_categories(categories,options)
    if categories.present?
      categories.order(:names_depth_cache_en).map do |category|
        if options[:as] == :static
          category.names_depth_cache(get_language)
        else
          search_link_to category.names_depth_cache(get_language), :category_path, category
        end
      end.join(', ').html_safe
    else
      '-'
    end
  end
  def search_link_to(lbl,path,obj)
    link_to lbl,send(path,obj,(@search ? {:search=>@search.id} : nil)) 
  end
end
