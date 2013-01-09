# -*- encoding : utf-8 -*-
class Building < ActiveRecord::Base
  has_many :classrooms, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true
end
