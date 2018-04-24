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
    blocks_valid = @blocks.all?(&:is_hash_valid?)
    unless blocks_valid
      Rails.logger.error 'Not all blocks are valid'
      return false
    end
    Rails.logger.debug 'all blocks are valid'
    expected_hash = '0'
    expected_hash = 0
    for i in 0..@blocks.size - 1
      Rails.logger.debug i
      return false if !@blocks[i].previous_block_hash == expected_hash
      expected_hash = @blocks[i].block_chain_hash
    end
    true
  end

  def merge(other)
    latest = find_latest_common_block(other)
    other_branch = other.blocks[(latest + 1)..(other.blocks.size - 1)]
    our_branch = @blocks[(latest + 1)..(blocks.size - 1)]

    if @blocks.size > other.blocks.size
      # our chain is longer, but retain "there" transactions
      other_branch.each do |block|
        transactions = block.transactions
        Rails.logger.debug "block #{block.inspect} has transactions: #{transactions.inspect}"
        # block.transactions=Transaction.none

        transactions.each do |t|
          Rails.logger.debug ' Nulling transactions block_id'
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
          Rails.logger.debug 'Nulling transactions block_id'
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
    b1s = @blocks
    b2s = other.blocks
    mx = [b1s.size, b2s.size].max
    mx.times { |i| break i - 1 if b1s[i] != b2s[i] }
  end

  attr_reader :blocks
end
