class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :session_id
      t.integer :subject_id
      t.string :customer_subject_id
      t.string :customer_client_subject_id
      t.string :customer_name
      t.integer :customer_id
      t.string :customer_client_name
      t.integer :customer_client_id
      t.integer :session_duration
      t.integer :reservation
      t.string :exam_code

      t.timestamps
    end
  end
end
