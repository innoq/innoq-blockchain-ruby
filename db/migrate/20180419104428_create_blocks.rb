class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.decimal :block_index, null: false
      t.timestamp :timestamp, null: false
      t.decimal :proof, null: false
      t.string :previous_block_hash, null: false

      t.timestamps
    end
  end
end
