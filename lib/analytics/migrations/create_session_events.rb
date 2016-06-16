class CreateSessionEvents < ActiveRecord::Migration
  def change
    create_table :session_events do |t|
      t.integer :session_id
      t.integer :event_type
      t.integer :timestamp
      t.integer :severity
      t.integer :proctor_id
      t.string :proctor_name

      t.timestamps
    end
  end
end
