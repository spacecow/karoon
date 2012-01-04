class User < ActiveRecord::Base
  attr_accessor :password
  before_create :set_role
  before_save :encrypt_password

  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_presence_of :email
  validates_uniqueness_of :email

  ROLES = %w(god admin vip member)

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
