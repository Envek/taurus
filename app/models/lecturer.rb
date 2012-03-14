class Lecturer < ActiveRecord::Base
  has_many :teaching_places, :dependent => :destroy
  has_many :charge_cards, :through => :teaching_places
  has_many :departments, :through => :teaching_places

  validates_uniqueness_of :name
  
  scope :by_name, lambda { |name| where('LOWER(lecturers.name) LIKE LOWER(?)', escape_name(name)) }
  
  private

  def self.escape_name(name)
    name.to_s.gsub('%', '\%').gsub('_', '\_') + '%'
  end
end
