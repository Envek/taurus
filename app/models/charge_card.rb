class ChargeCard < ActiveRecord::Base
  before_update :remove_pairs
  after_save :update_editor_name

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
    n = [discipline.try(:name), lesson_type.try(:name), groups].compact.join(", ")
    n + "; #{hours_quantity} ч."
  end

  def name_for_pair_edit
    [teaching_place.name, assistant_teaching_place.try(:to_label), name].compact.join(", ")
  end

  def hours_quantity
    weeks_quantity * hours_per_week
  end

  def editor_name_include? word
    if editor_name
      Unicode::downcase(editor_name).include? Unicode.downcase(word)
    end
  end

  def update_editor_name
    reload
    editor_name = ActiveRecord::Base.sanitize(self.name_for_pair_edit)
    # It's not good idea to use raw SQL, but it's the only solution that works
    ActiveRecord::Base.connection.execute("UPDATE charge_cards SET editor_name = #{editor_name} WHERE id = #{self.id};")
  end

  private

  def remove_pairs
    pairs.destroy_all if teaching_place_id_changed?
  end
end

