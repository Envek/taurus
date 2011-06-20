class ChargeCard < ActiveRecord::Base
  before_update :remove_pairs

  belongs_to :discipline
  belongs_to :teaching_place
  belongs_to :assistant_teaching_place, :class_name => "TeachingPlace", :foreign_key => "assistant_id"

  belongs_to :lesson_type
  has_many :jets, :dependent => :destroy
  has_many :groups, :through => :jets
  has_many :pairs, :dependent => :destroy

  validates_presence_of :discipline, :lesson_type, :teaching_place, :weeks_quantity, :hours_per_week
  validates_numericality_of :weeks_quantity, :hours_per_week

  def name
    groups = []
    self.groups.each do |group|
      groups << group.name
    end
    [discipline.try(:name), lesson_type.try(:name), groups].compact.join(", ")
  end

  def name_for_pair_edit
    teaching_place.name + ', ' + name
  end

  def hours_quantity
    weeks_quantity * hours_per_week
  end

  private

  def remove_pairs
    pairs.destroy_all if teaching_place_id_changed?
  end
end

