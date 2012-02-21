def create_category(s,id=nil)
  Factory(:category,:name_en=>s,:parent_id=>id) 
end
