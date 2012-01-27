class TeachingPlace < ActiveRecord::Base
  belongs_to :department
  belongs_to :lecturer
  belongs_to :position
  has_many :charge_cards, :dependent => :destroy
  has_many :assistant_charge_cards, :class_name => "ChargeCard", :foreign_key => "assistant_id"

  validates_presence_of :department, :lecturer
  validates_uniqueness_of :lecturer_id, :scope => :department_id

  def name
    (lecturer.try(:name) or '') + ' (' + (department.try(:name) or '') + ')'
  end

  def to_label
    lecturer.name
  end
  
  def whish
    lecturer.whish
  end
  
end
