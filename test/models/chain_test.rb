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

end
