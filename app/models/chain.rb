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
    #if block.size >

    # Längste Chain behalten
    # überflüssige Blöcke aus der DB löschen. Dabei Pro BLock die Transactions "rausnehmen", Transactions persistieren
    # "verlorene" Transaktionen

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
