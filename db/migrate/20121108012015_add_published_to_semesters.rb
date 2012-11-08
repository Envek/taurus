class AddPublishedToSemesters < ActiveRecord::Migration
  def change
  	add_column :semesters, :published, :bool, :null => false, :default => false
  end
end
