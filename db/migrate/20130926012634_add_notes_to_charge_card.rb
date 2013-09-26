class AddNotesToChargeCard < ActiveRecord::Migration
  def change
    add_column :charge_cards, :note, :string
  end
end
