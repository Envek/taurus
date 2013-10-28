# -*- encoding : utf-8 -*-
class LessonType < ActiveRecord::Base
  has_many :charge_cards, :dependent => :nullify
  has_many :training_assignments, dependent: :destroy, inverse_of: :lesson_type

  validates_presence_of :name

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
