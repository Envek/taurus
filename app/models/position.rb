class Position < ActiveRecord::Base
  has_many :teaching_places, :dependent => :nullify
end
