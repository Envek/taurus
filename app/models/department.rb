# -*- encoding : utf-8 -*-
class Department < ActiveRecord::Base
  belongs_to :faculty
  has_many :classrooms, :dependent => :nullify
  has_many :disciplines, :dependent => :destroy
  has_many :charge_cards, :through => :disciplines
  has_many :teaching_places, :dependent => :destroy
  has_many :lecturers, :through => :teaching_places
  has_many :specialities, :dependent => :destroy
  has_many :groups, through: :specialities
  has_and_belongs_to_many :dept_heads, :class_name => "User"
  belongs_to :dept_head, class_name: 'Lecturer'

  validates :name, :presence => true, :uniqueness => true
  validates :short_name, :presence => true, :uniqueness => true
  validates :gosinsp_code, :uniqueness => {:allow_nil => true},
    :numericality => {:only_integer => true, :greater_than => 0, :allow_nil => true}
  validates :faculty_id, :presence => true

  after_update :update_charge_cards_editor_titles, :if => :name_changed?

  default_scope where('departments.faculty_id IS NOT NULL').order(:gosinsp_code, :name)

  protected

  def update_charge_cards_editor_titles
    ChargeCard.transaction(:requires_new => true) do
      charge_cards.find_in_batches(:include => ChargeCard.association_dependencies) do |cards|
        cards.each do |card|
          card.save(:validate => false)
        end
      end
    end
  end

end
