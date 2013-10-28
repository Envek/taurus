# -*- encoding : utf-8 -*-
class Faculty < ActiveRecord::Base
  has_many :departments, :dependent => :destroy
  has_and_belongs_to_many :users

  validates :name, :presence => true, :uniqueness => true
  validates :full_name, :presence => true, :uniqueness => true
end
