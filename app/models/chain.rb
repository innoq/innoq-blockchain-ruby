class Chain

  def initialize(blocks)
    @blocks = blocks
  end

  # render this block as josn and apply robert sort to the field members
  def as_json(options=nil)
    {
      blocks: @blocks.as_json
    }
  end

  # Make sure this chain is valid
  def validate()
    # todo
  #  Digest::SHA256.hexdigest(as_json.to_s)
  end
end
