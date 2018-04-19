require 'json'

class Miner
  def mine(params)
    puts "Miner:mine #{params.inspect}"
    block = Block.new(params)
    block.proof = 0
    until (Digest::SHA256.hexdigest block.as_json.to_s).start_with?('0000')
      block.proof += 1
    end

    block
  end
end
