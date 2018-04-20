class Chain

  def initialize(blocks)
    @blocks = blocks
  end

  def as_json(options=nil)
    {
      blocks: @blocks.as_json,
      valid: is_hash_valid?
    }
  end

  # Make sure this chain is valid
  def is_hash_valid?
    if !@blocks.all?(&:is_hash_valid?)
      return false;
    end

    expected_hash = 0;
    for i in 1..@blocks.size-1
      puts i
      if !@blocks[i].previous_block_hash == expected_hash
        return false
      end
      expected_hash = @blocks[i].block_chain_hash
    end
    return true;
    ## Validate hash points to previous lbock
  end


  def merge(other)
    latest = find_latest_common_block(other)
    other_branch=other.blocks[latest+1..other.blocks.size-1]
    our_branch= @blocks[latest+1..blocks.size-1]
    lost_blocks=[]

    if @blocks.size > other.blocks.size
      # our chain is longer, but retain "there" transactions
      other_branch.each { |block|
        transactions = block.transactions
        puts "block #{block.inspect} has transactions: #{transactions.inspect}"
        #block.transactions=Transaction.none

        transactions.each {|t|
          puts " Nulling transactions block_id"
          t.block_id=nil
        }
        transactions.each(&:save)
      }
    else
      # There chain is longer
      # unassign lost transactions, delete blocks
      #
      our_branch.each {|block|
          transactions = block.transactions
          block.transactions = Transaction.none
          block.delete
          transactions.each(&:save)
      }
      # store all new blocks from other
      other_branch.each(&:save)
      @blocks=other.blocks
    end
  end

  def find_latest_common_block(other)
    for i in 0..[@blocks.size, other.blocks.size].max
      if @blocks[i].block_chain_hash != other.blocks[i].block_chain_hash
        return i - 1;
      end
      i
    end
  end

  attr_reader :blocks

end
