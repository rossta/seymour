class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :auditable_id
      t.string :auditable_type
      t.integer :actor_id

      t.timestamps
    end
  end
end
