class Block < ApplicationRecord
  has_many :transactions


  # render this block as josn and apply robert sort to the field members
  def as_json()
    transactionsJson = transactions.map{|transaction|  "{\"id\":\"#{transaction.transaction_id}\",\"timestamp\":#{transaction.timestamp.to_i},\"payload\":\"#{transaction.payload}\"}"}.join","

     "{\"index\":#{block_index.round()},\"timestamp\":#{timestamp.to_i},\"proof\":#{proof.round()},\"transactions\":[#{transactionsJson}],\"previousBlockHash\":\"#{previous_block_hash}\"}"


  end
end
