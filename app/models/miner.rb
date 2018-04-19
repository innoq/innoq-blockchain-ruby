require 'json'

class Miner
  THREAD_COUNT = 4

  def mine(params, prefix = '0000', stride = 1)
    puts "Miner:mine #{params.inspect}"
    mine_with_all_hands(params, prefix)
  end

  def mine_with_previous(previous, transactions = [])
    new_block = {block_index: previous.block_index + 1, timestamp: Time.now, transactions: transactions, previous_block_hash: previous.block_chain_hash}
    mine(new_block)
  end

  private

  def try_next(block, prefix, stride)
    block.proof += stride
    $stderr.puts "Try Block: #{block.inspect}"
    block.hash_starts_with?(prefix)
  end


    def mine_with_all_hands(params, prefix, thread_count = THREAD_COUNT)
      mu = Mutex.new
      threads = []
      found = nil

      thread_count.times do |i|
        threads << Thread.new do
          block = Block.new(params)
          until found do
            if try_next(block, prefix, i + 1)
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
