class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :subject_id
      t.string  :subject_type
      t.integer :actor_id

      t.timestamps
    end
  end
end
