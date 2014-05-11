class AddUidToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :uid, :string
    remove_column :tasks, :user_id
  end
end
