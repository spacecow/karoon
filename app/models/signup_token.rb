class SignupToken < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token

  validates :email, presence:true

  private

    def generate_token
      self.token = Digest::SHA1.hexdigest([Time.now,rand].join)
    end
end
