require 'test_helper'
require 'time'

class MinerTest < ActiveSupport::TestCase
  test 'the truth' do
    assert true
  end

  test 'mine' do
    miner = Miner.new
    puts "XXX #{miner.mine(block_index: 1, timestamp: Time.now, transactions: [], previous_block_hash: 'abc')}"
  end
end
