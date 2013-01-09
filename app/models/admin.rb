# -*- encoding : utf-8 -*-
class Admin < User
  devise :database_authenticatable, :rememberable, :trackable,
    :validatable, :encryptable, :encryptor => :sha1
end
