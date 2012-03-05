class Authorship < ActiveRecord::Base
  belongs_to :book
  belongs_to :author
end
# == Schema Information
#
# Table name: authorships
#
#  id         :integer(4)      not null, primary key
#  author_id  :integer(4)
#  book_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

