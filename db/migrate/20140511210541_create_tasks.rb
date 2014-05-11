class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true
      t.string :text
      t.boolean :is_done
      t.boolean :is_reminder

      t.timestamps
    end
  end
end
