class ManyDisciplinesInChargeCard < ActiveRecord::Migration

  class ChargeCard < ActiveRecord::Base
    belongs_to :discipline
    has_and_belongs_to_many :disciplines
  end

  def up
    ChargeCard.transaction do

      create_table :charge_cards_disciplines do |column|
        column.references :charge_card, null: false
        column.references :discipline,  null: false
      end
      add_index :charge_cards_disciplines, [:charge_card_id, :discipline_id], unique: true, name: 'charge_cards_disciplines_main_index'

      say_with_time "Migrating charge card's disciplines from single to multiple. It may take a while." do
        ChargeCard.find_each do |charge_card|
          charge_card.disciplines = [charge_card.discipline].compact
        end
      end

      change_table :charge_cards do |column|
        column.remove :discipline_id
      end

    end
  end

  def down
    ChargeCard.transaction do

      change_table :charge_cards do |column|
        column.references :discipline_id
      end

      say_with_time "Migrating charge card's disciplines from multiple to single. It may take a while. DATA LOSS WILL OCCUR!" do
        ChargeCard.find_each do |charge_card|
          charge_card.discipline = charge_card.disciplines.first
        end
      end

      drop_table :charge_cards_disciplines

    end
  end
end
