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
    @blocks.all?(&:is_hash_valid?)

    ## Validate hash points to previous lbock
  end
end
