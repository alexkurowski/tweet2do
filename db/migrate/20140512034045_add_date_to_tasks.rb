class AddDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :date, :datetime
  end
end
