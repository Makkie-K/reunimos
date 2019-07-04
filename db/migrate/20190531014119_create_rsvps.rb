class CreateRsvps < ActiveRecord::Migration[5.2]
  def change
    create_table :rsvps do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end
end
