require 'test_helper'
require 'json'

class ChainTest < ActiveSupport::TestCase

  test "invalid Chains are invalid" do
    block = blocks(:one)
    block.proof = 4711
    chain =  Chain.new([block])
    assert_not chain.is_hash_valid?
  end

  test "a Valid Chain is valid" do
    assert Chain.new([blocks(:one), blocks(:two)]).is_hash_valid?
  end


  test "invalid previous is checked" do
   one = blocks(:one)
   two = blocks(:two)
   two.previous_block_hash = "234567890765432"
   chain= Chain.new([one, two])
   assert_not chain.is_hash_valid?
  end


  test "find Latest Common Block Workd" do
    miner = Miner.new
    one = blocks(:one)
    two = blocks(:two)
    three_a = miner.mine_with_previous(two)
    three_b = miner.mine_with_previous(two, [Transaction.new(payload: "foo")])

    chain_a = Chain.new([one,two,three_a])
    chain_b = Chain.new([one,two,three_b])

    assert_equal 1, chain_a.find_latest_common_block(chain_b)
  end

  test "find Latest Common if no common" do
    miner = Miner.new
    one = blocks(:one)
    two = blocks(:two)
    chain_a = Chain.new([one])
    chain_b = Chain.new([two])

    assert_equal -1, chain_a.find_latest_common_block(chain_b)
  end

end
