class Block < ApplicationRecord
  has_many :transactions

  default_scope { order(block_index: :desc) }
  accepts_nested_attributes_for :transactions

  PREFIX = '0000'.freeze

  # render this block as josn and apply robert sort to the field members
  def to_builder
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

  def as_json(_options = nil)
    to_builder.attributes!
  end

  def hash_starts_with?(prefix)
    block_chain_hash.start_with?(prefix)
  end

  def block_chain_hash
    Digest::SHA256.hexdigest(as_json.to_json)
  end

  def is_hash_valid?
    block_chain_hash.start_with?(PREFIX)
  end

  def cache_json_fragments
    temp = proof
    magic_int = 324_567_890_765_432
    self.proof = magic_int
    json = as_json.to_json
    @json_parts = json.split(/324567890765432/, 2)
    puts 'Json Fragments are: ' + @json_parts.inspect
    self.proof = temp
  end

  def hash_valid_cached?
    Digest::SHA256.hexdigest(@json_parts[0] + proof.to_s + @json_parts[1]).start_with?(PREFIX)
  end
end
