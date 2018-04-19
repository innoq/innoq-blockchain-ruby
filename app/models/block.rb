class Block < ApplicationRecord
  has_many :transactions

  default_scope { order(block_index: :desc )}
  accepts_nested_attributes_for :transactions

  after_initialize do |block|
    block.proof = 0
  end


  # render this block as josn and apply robert sort to the field members
  def as_json()
    transactionsJson = transactions.map(&:as_json).join","
     "{\"index\":#{block_index.round()},\"timestamp\":#{timestamp.to_i},\"proof\":#{proof.round()},\"transactions\":[#{transactionsJson}],\"previousBlockHash\":\"#{previous_block_hash}\"}"
  end

  def hash_starts_with?(prefix)
    block_chain_hash.start_with?(prefix)
  end

  def block_chain_hash
    Digest::SHA256.hexdigest(as_json.to_s)
  end
end
