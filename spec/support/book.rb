def create_book(s); Factory(:book,:title=>s) end
def fill_in_book(i=0,title="A",price="1000",cat="B")
  if title.instance_of? Hash
    title.each do |k,v|
      label = k.to_s.split('_').map(&:capitalize).join(' ')
      if label == "Image"
        li(k,i).attach_file label, v
      else
        li(k,i).fill_in label, :with => v
      end
    end
  else
    li(:title,i).fill_in 'Title', :with => title
    li(:regular_price,i).fill_in 'Regular Price', :with => price
    li(:category_tokens,i).fill_in 'Category', :with => cat
  end
end
