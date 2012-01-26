atom_feed do |feed|
  feed.title "Who bought #{@book.title}"

  latest_order = @book.orders.sort_by(&:updated_at).last
  feed.updated(latest_order && latest_order.updated_at)

  @book.orders.each do |order|
    feed.entry(order) do |entry|
      entry.title "Order #{order.id}"
      entry.summary type: 'xhtml' do |xhtml|
        xhtml.p "Shipped to #{order.address}"
      end
    end
  end
end
