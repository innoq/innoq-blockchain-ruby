class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event, null: false
      t.text :data, null: false

      t.timestamps
    end
  end
end
