class MakeHoursInWeekFloatInChargeCards < ActiveRecord::Migration
  def up
    change_table :charge_cards do |column|
      column.change :hours_per_week, :decimal, precision: 5, scale: 2
    end
  end

  def down
    say 'WARNING! Due to convertation from decimal to integer, data loss may occur!'
    change_table :charge_cards do |column|
      column.change :hours_per_week, :integer
    end
  end
end
