class Pair < ActiveRecord::Base
  belongs_to :charge_card
  belongs_to :classroom
  belongs_to :timeslot

  def name
    'Пара'
  end

  def lecturer
    self.try(:charge_card).try(:teaching_place).try(:name)
  end

  def discipline
    self.try(:charge_card).try(:discipline).try(:name)
  end

  def groups
    groups_string = []
    unless (groups = self.try(:charge_card).try(:groups)).nil?
      groups.each do |group|
        groups_string << group.try(:name)
      end
    end
    groups_string.map{|g| g + ', '}.to_s.chop.chop
  end
end
