class AddUserToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user, :string
  end
end
