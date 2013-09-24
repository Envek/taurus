# -*- encoding : utf-8 -*-
class Lecturer < ActiveRecord::Base
  has_many :teaching_places, :dependent => :destroy
  has_many :charge_cards, :through => :teaching_places
  has_many :departments, :through => :teaching_places

  validates_uniqueness_of :name
  
  scope :by_name, lambda { |name| where('LOWER(lecturers.name) LIKE LOWER(?)', escape_name(name)) }

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

  def self.escape_name(name)
    name.to_s.gsub('%', '\%').gsub('_', '\_') + '%'
  end

  def short_name
    parts = name.split(/[\.\s]/)
    "#{parts.first}\u00A0#{parts[1..-1].map(&:first).join('.')}."
  end
end
