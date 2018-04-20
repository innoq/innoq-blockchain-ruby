class Block < ApplicationRecord
  has_many :transactions

  default_scope { order(block_index: :desc )}
  accepts_nested_attributes_for :transactions

  # render this block as josn and apply robert sort to the field members
  def to_builder()
    Jbuilder.new do |json|
      json.index block_index
      json.timestamp timestamp.to_i
      json.proof proof

      json.transactions(transactions) do |transaction|
        json.merge! transaction.to_builder.attributes!
      end
      json.previousBlockHash previous_block_hash
    end
  end

  def as_json(options=nil)
    to_builder.attributes!
  end

  def block_chain_hash()
    Digest::SHA256.hexdigest(as_json.to_json)
  end

  def valid?
    block_chain_hash.start_with?('0000')
  end


end
