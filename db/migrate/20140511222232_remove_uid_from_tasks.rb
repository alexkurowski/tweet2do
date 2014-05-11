class RemoveUidFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :uid, :string
    add_column :tasks, :uid, :integer
  end
end
