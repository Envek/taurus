class ChargecardsAddSearchtitle < ActiveRecord::Migration
  def self.up
    change_table :charge_cards do |t|
      t.string "editor_name"
    end
    ChargeCard.all.each do |card|
      card.save # update_editor_name method will be invoked automatically
    end
  end

  def self.down
    change_table :charge_cards do |t|
      t.remove "editor_name"
    end
  end
end
