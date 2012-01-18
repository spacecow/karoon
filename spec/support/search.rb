def create_search(s,id=nil)
  Factory(:search,:keywords=>s,:category_id=>id)
end
def search(id); div(:search,id) end
def search_author_match(id)
  search(0).div(:author_match) 
end
def search_book_match(id)
  search(0).div(:book_match) 
end
def search_category_match(id)
  search(0).div(:category_match) 
end
def search_keywords(id)
  search(0).div(:keywords) 
end
def search_ip(id)
  search(0).div(:ip) 
end
def search_userid(id)
  search(0).div(:userid) 
end
