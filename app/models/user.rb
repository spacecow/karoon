class User < ActiveRecord::Base
  has_many :orders
  has_many :searches
  has_many :books
  has_many :blank_books, :class_name => 'Book', :conditions => {:user_id => nil}
  accepts_nested_attributes_for :blank_books
  has_one :signup_token

  attr_accessor :password
  before_create :set_role
  before_save :encrypt_password

  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :userid, :unless => Proc.new{|user| user.userid.blank? } 

  ADMIN     = 'admin'
  GOD       = 'god'
  MEMBER    = 'member'
  MINIADMIN = 'miniadmin'
  VIP       = 'vip'
  ROLES     = [GOD,ADMIN,MINIADMIN,VIP,MEMBER]

  def cart; current_cart end
  def role?(s); roles.include?(s.to_s) end
  def roles; ROLES.reject{|r| ((roles_mask||0) & 2**ROLES.index(r)).zero? } end

  class << self
    def authenticate(email,password)
      user = find_by_email(email)
      if user && user.password_hash == BCrypt::Engine.hash_secret(password,user.password_salt)
        user
      else
        nil
      end
    end

    def role(s); 2**ROLES.index(s.to_s) end
  end

  private

    def encrypt_password
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
      end
    end

    def set_role; self.roles_mask = User.role(:member) unless roles_mask end
end
# == Schema Information
#
# Table name: users
#
#  id            :integer(4)      not null, primary key
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  roles_mask    :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  userid        :string(255)
#

