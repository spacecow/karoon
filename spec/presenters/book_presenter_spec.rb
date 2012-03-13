require 'spec_helper'

describe BookPresenter do
  before(:each) do
    @presenter = BookPresenter.new(Book.new, view)
  end
    
  it "" do
    @presenter.image_thumb.should include("Books-pile")
  end
end
