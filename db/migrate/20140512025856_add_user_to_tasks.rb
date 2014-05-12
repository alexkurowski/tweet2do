class AddUserToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user, :string
    remove_column :tasks, :user_id
  end
end
