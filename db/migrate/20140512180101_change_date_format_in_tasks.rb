class ChangeDateFormatInTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :date, :timestamp
  end
end
