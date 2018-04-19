require 'json'

class Miner
  def mine(params)
    puts "Miner:mine #{params.inspect}"
    block = Block.new(params)
    block.proof = 0
    until block.block_chain_hash.start_with?('0000')
      block.proof += 1
    end
    block
  end

  def mine_with_previous(previous, transactions = [])
    new_block = { block_index: previous.block_index + 1, timestamp: Time.now, transactions: transactions, previous_block_hash: previous.block_chain_hash }
    mine(new_block)
  end


end
