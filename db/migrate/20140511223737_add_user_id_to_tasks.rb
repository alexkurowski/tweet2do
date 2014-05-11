class AddUserIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user_id, :integer
    remove_column :tasks, :uid
  end
end
