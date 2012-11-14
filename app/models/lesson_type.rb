class LessonType < ActiveRecord::Base
  has_many :charge_cards, :dependent => :nullify

  validates_presence_of :name
end
