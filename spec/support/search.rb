def create_search(s,id=nil)
  Factory(:search,:keywords=>s,:category_id=>id)
end
