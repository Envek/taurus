class Faculty < ActiveRecord::Base
  has_many :departments, :dependent => :destroy
end
