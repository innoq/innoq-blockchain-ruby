class Block < ApplicationRecord
  has_many :transactions

  def as_json()
    transactionsJson = transactions.map{|transaction|  "{\"id\":\"#{transaction.transaction_id}\",\"payload\":\"#{transaction.payload}\",\"timestamp\":#{transaction.timestamp.to_i}}"}.join","

     "{\"index\":#{block_index.round()},\"previousBlockHash\":\"#{previous_block_hash}\",\"proof\":#{proof.round()},\"timestamp\":#{timestamp.to_i}," +
      "\"transactions\":[#{transactionsJson}]}"

  end
end
