require 'json'

class Miner
  THREAD_COUNT = 4

  def mine(params, stride = 1)
    puts "Miner:mine #{params.inspect}"
    mine_with_all_hands(params)
  end

  def mine_with_previous(previous, transactions = [])
    new_block = {block_index: previous.block_index + 1, timestamp: Time.now, transactions: transactions, previous_block_hash: previous.block_chain_hash}
    mine(new_block)
  end

  # Mine using the latest block from db and the current transactions
  def new_mine
    previous = Block.first
    transactions = Transaction.open.take(5)
    block = mine_with_previous(previous, transactions)
    block.save
    block
  end

  private

  def try_next(block, stride)
    block.proof += stride
    # $stderr.puts "Try Block: #{block.inspect}"
    block.is_hash_valid?
  end


  def mine_with_all_hands(params, thread_count = THREAD_COUNT)
    mu = Mutex.new
    threads = []
    found = nil

    thread_count.times do |i|
      threads << Thread.new do
        block = Block.new(params)
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
