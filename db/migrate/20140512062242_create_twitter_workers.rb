class CreateTwitterWorkers < ActiveRecord::Migration
  def change
    create_table :twitter_workers do |t|

      t.timestamps
    end
  end
end
