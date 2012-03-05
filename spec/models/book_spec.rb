require 'spec_helper'

describe Book do
  context "delete" do
    before(:each){ @book = Factory(:book) }

    it "is not possible if there are referenced line items" do
      cart = Factory(:cart)
      line_item = cart.line_items.build(:book_id=>@book.id)
      line_item.save!
      lambda do
        @book.destroy
      end.should change(Book,:count).by(0)
    end 

    it "book without line items" do
      lambda do
        @book.destroy
      end.should change(Book,:count).by(-1)
    end
  end
end
# == Schema Information
#
# Table name: books
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  image         :string(255)
#  summary       :text
#  user_id       :integer(4)
#  regular_price :string(255)
#

