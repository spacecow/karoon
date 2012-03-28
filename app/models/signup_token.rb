class SignupToken < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token

  validates :email, presence:true
  attr_accessible :email

  private

    def generate_token
      self.token = Digest::SHA1.hexdigest([Time.now,rand].join)
    end
end
# == Schema Information
#
# Table name: signup_tokens
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  token      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

