class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_id
      t.timestamp :timestamp
      t.string :payload
      t.references :block, foreign_key: true

      t.timestamps
    end
  end
end
