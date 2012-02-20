class AddPopulationToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :population, :integer
  end

  def self.down
    remove_column :groups, :population
  end
end
