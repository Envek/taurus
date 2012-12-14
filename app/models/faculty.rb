class Faculty < ActiveRecord::Base
  has_many :departments, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true
  validates :full_name, :presence => true, :uniqueness => true
end
