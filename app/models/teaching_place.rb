class TeachingPlace < ActiveRecord::Base
  belongs_to :department
  belongs_to :lecturer
  belongs_to :position
  has_many :charge_cards, :dependent => :destroy
  has_many :assistant_charge_cards, :class_name => "ChargeCard"

  validates_presence_of :department, :lecturer
  validates_uniqueness_of :lecturer_id, :scope => :department_id

  def name
    lecturer.name + ' (' + department.name + ')'
  end

  def to_label
    lecturer.name
  end
  
  def assistant_charge_cards
    ChargeCard.all(:conditions => {'assistant_id' => self.id})
  end
  
end
