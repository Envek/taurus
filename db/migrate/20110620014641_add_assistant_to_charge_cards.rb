class AddAssistantToChargeCards < ActiveRecord::Migration
  def self.up
    change_table :charge_cards do |t|
      t.integer "assistant_id"
    end
  end

  def self.down
    t.remove "assistant_id"
  end
end
