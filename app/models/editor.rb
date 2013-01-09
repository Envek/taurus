# -*- encoding : utf-8 -*-
class Editor < User
  devise :database_authenticatable, :rememberable, :trackable,
    :validatable, :encryptable, :encryptor => :sha1
end
