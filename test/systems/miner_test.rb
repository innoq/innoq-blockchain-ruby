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

  test 'mine_with_previous' do
    miner = Miner.new
    old = blocks(:one)
    newBlock = miner.mine_with_previous(old)

    assert newBlock.previous_block_hash == old.block_chain_hash
  end
end
