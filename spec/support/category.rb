def create_category(s,id=nil)
  Factory(:category,:name=>s,:parent_id=>id) 
end
