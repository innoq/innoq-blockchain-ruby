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
end
