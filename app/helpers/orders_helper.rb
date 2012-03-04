module OrdersHelper
  def listed_books(order)
    link_to order.line_item_book_titles.join(', '), order
  end
end
