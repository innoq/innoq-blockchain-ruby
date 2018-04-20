class Chain

  def initialize(blocks)
    @blocks = blocks
  end

  def as_json(options=nil)
    {
      blocks: @blocks.as_json
    }
  end

  # Make sure this chain is valid
  def valid?()
    blocks.each do |block|
       blocks.all? &:valid?
    end
    ## Validate hash points to previous lbock
  end
end
