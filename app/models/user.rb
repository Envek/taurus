class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable,
    :validatable, :encryptable, :encryptor => :sha1

  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me

  protected
   def password_required?
     new_record? || destroyed? || password.present? || password_confirmation.present?
   end
end
