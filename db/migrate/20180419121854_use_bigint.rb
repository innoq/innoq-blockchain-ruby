class UseBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :blocks, :block_index, :bigint
    change_column :blocks, :proof, :bigint
  end
end
