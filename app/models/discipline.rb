# -*- encoding : utf-8 -*-
class Discipline < ActiveRecord::Base
  belongs_to :department
  has_many :charge_cards, :dependent => :destroy
  has_many :teaching_plans, :dependent => :destroy
  has_and_belongs_to_many :training_assignments, join_table: :disciplines_in_assignments

  validates_presence_of :department, :name, :short_name
  validates_uniqueness_of :name, :scope => :department_id
  validates_length_of :short_name, :maximum => 24

  after_update :update_charge_cards_editor_titles, :if => :name_changed?

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
