class AddTimezoneToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :time_offset, :integer
  end
end
