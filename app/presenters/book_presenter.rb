class BookPresenter < BasePresenter
  presents :book

  def image_thumb
    h.link_to h.image_tag(image_thumb_name), book
  end

  private

    def image_thumb_name
      if book.image_url.present?
        book.image_url(:thumb)
      else
        'books-pile.jpg'
      end
    end
end
