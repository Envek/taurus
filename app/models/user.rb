# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable,
    :validatable, :encryptable, :encryptor => :sha1

  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me

  has_and_belongs_to_many :departments
  has_and_belongs_to_many :faculties

  protected
   def password_required?
     new_record? || destroyed? || password.present? || password_confirmation.present?
   end
end
