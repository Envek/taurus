# -*- encoding : utf-8 -*-
class Supervisor < User
  devise :database_authenticatable, :rememberable, :trackable,
    :validatable, :encryptable, :encryptor => :sha1
end
