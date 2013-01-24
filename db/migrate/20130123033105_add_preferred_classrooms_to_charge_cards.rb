class AddPreferredClassroomsToChargeCards < ActiveRecord::Migration
  def change
  	create_table :charge_cards_preferred_classrooms, :id => false do |t|
      t.integer :charge_card_id
      t.integer :classroom_id
    end
  end
end
