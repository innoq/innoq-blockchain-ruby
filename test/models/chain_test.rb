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


  test "find Latest Common Block Work" do
    miner = Miner.new
    one = blocks(:one)
    two = blocks(:two)
    three_a = miner.mine_with_previous(two)
    three_b = miner.mine_with_previous(two, [Transaction.new(payload: "foo")])

    chain_a = Chain.new([one,two,three_a])
    chain_b = Chain.new([one,two,three_b])

    assert_equal 1, chain_a.find_latest_common_block(chain_b)
  end

  test "find Latest Common Block Works again" do
    miner = Miner.new
    one = blocks(:one)
    two = blocks(:two)
    three_a = miner.mine_with_previous(two)
    three_b = miner.mine_with_previous(two, [Transaction.new(payload: "foo")])

    chain_a = Chain.new([one,two,three_a])
    chain_b = Chain.new([one])

    assert_equal 0, chain_a.find_latest_common_block(chain_b)
  end

  test "find Latest Common if no common" do
    miner = Miner.new
    one = blocks(:one)
    two = blocks(:two)
    chain_a = Chain.new([one])
    chain_b = Chain.new([two])

    assert_equal -1, chain_a.find_latest_common_block(chain_b)
  end


  test "merge Chains" do
    miner = Miner.new
    one = blocks(:one)
    two = blocks(:two)
    three_a = miner.mine_with_previous(two)
    four_a = miner.mine_with_previous(three_a)
    lost_transaction = Transaction.new(payload: "Lost Transaction")
    three_b = miner.mine_with_previous(two, [lost_transaction])

    chain_a = Chain.new([one,two,three_a, four_a])
    chain_b = Chain.new([one,two,three_b])
    #
    chain_a.merge(chain_b)

    Rails.logger.debug "Open Transactions:"

    assert Transaction.open.any? {|t|
      t == lost_transaction
    }
  end
end
