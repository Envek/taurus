# -*- encoding : utf-8 -*-
class DeptHead < User
  belongs_to :department
  devise :database_authenticatable, :rememberable, :trackable,
    :validatable, :encryptable, :encryptor => :sha1

  validates_presence_of :department
end
