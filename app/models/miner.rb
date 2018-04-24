require 'json'

class Miner
  THREAD_COUNT = 4

  # Mine using the latest block from db and the current transactions
  def mine(block_params = nil)
    if block_params
      dig_with_all_hands(block_params)
    else
      previous = Block.first
      transactions = Transaction.open.from_oldest.take(5)
      block = mine_with_previous(previous, transactions)
      block.save
      block
    end
  end

  def mine_with_previous(previous, transactions = [])
    new_block = {block_index: previous.block_index + 1, timestamp: Time.now, transactions: transactions, previous_block_hash: previous.block_chain_hash}
    Rails.logger.debug "Miner:mine #{new_block.inspect}"
    mine_value = dig_with_all_hands(new_block)
    block = mine_value
    block.save
    block
  end


  private

  def try_next(block, stride)
    block.proof += stride
    block.hash_valid_cached?
  end


  def dig_with_all_hands(params, thread_count = THREAD_COUNT)
    mu = Mutex.new
    threads = []
    found = nil

    thread_count.times do |i|
      threads << Thread.new do
        block = Block.new(params)
        block.cache_json_fragments
        block.proof = i - thread_count # try_next increments
        until found do
          if try_next(block, thread_count)
            mu.synchronize do
              found ||= block
            end
          end
        end
      end
    end
    threads.each(&:join)
    found
  end
end
