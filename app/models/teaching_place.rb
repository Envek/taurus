# -*- encoding : utf-8 -*-
class TeachingPlace < ActiveRecord::Base
  belongs_to :department
  belongs_to :lecturer
  belongs_to :position
  has_many :charge_cards, :dependent => :nullify
  has_many :assistant_charge_cards, :dependent => :nullify,
           :class_name => "ChargeCard", :foreign_key => "assistant_id"

  validates_presence_of :department, :lecturer
  validates_uniqueness_of :lecturer_id, :scope => :department_id

  def name
    (lecturer.try(:name) or '') + ' (' + (department.try(:name) or '') + ')'
  end

  def to_label
    lecturer.name
  end
  
  delegate :whish, :to => :lecturer
  
end
