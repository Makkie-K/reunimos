class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event_name
      t.text :description
      t.datetime :event_date
      t.string :location
      t.integer :creator_id

      t.timestamps
    end
  end
end
