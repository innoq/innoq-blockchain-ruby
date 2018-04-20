class Chain
  def initialize(blocks)
    @blocks = blocks
  end

  def as_json(_options = nil)
    {
      blocks: @blocks.as_json,
      valid: is_hash_valid?
    }
  end

  # Make sure this chain is valid
  def is_hash_valid?
    return false unless @blocks.all?(&:is_hash_valid?)

    expected_hash = 0
    for i in 1..@blocks.size - 1
      puts i
      return false if !@blocks[i].previous_block_hash == expected_hash
      expected_hash = @blocks[i].block_chain_hash
    end
    true
    ## Validate hash points to previous lbock
  end

  def merge(other)
    latest = find_latest_common_block(other)
    other_branch = other.blocks[(latest + 1)..(other.blocks.size - 1)]
    our_branch = @blocks[(latest + 1)..(blocks.size - 1)]

    if @blocks.size > other.blocks.size
      # our chain is longer, but retain "there" transactions
      other_branch.each do |block|
        transactions = block.transactions
        puts "block #{block.inspect} has transactions: #{transactions.inspect}"
        # block.transactions=Transaction.none

        transactions.each do |t|
          puts ' Nulling transactions block_id'
          t.block_id = nil
        end
        transactions.each(&:save)
      end
      return false
    else
      # There chain is longer
      # unassign lost transactions, delete blocks
      #
      our_branch.each do |block|
        transactions = block.transactions
        transactions.each do |t|
          puts 'Nulling transactions block_id'
          t.block_id = nil
        end
        block.delete
        transactions.each(&:save)
      end
      # store all new blocks from other
      other_branch.each(&:save)
      @blocks = other.blocks
      return true
    end
  end

  def find_latest_common_block(other)
    range_end = [@blocks.size, other.blocks.size].min - 1
    for i in (0..range_end)
      puts i
      if @blocks[i].block_chain_hash != other.blocks[i].block_chain_hash
        return i - 1
      end
      i
    end
    range_end
  end

  attr_reader :blocks
end
