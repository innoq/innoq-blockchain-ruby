class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.boolean :available
      t.string :host
      t.string :node_id

      t.timestamps
    end
  end
end
