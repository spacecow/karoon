def create_category(s,id=nil)
  Factory(:category,:name_en=>s,:parent_id=>id) 
end

def fill_in_owner
  visit new_book_path
  fill_in 'Title', with:'A new title'
  fill_in 'Regular Price', with:'1000'
  category = create_category('test')
  fill_in 'Category', with:category.id 
end
