require 'test_helper'
require 'json'

class BlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  #
   test "can serialize to json" do

     transaction1 = Transaction.new(transaction_id:"b3c973e2-db05-4eb5-9668-3e81c7389a6d", timestamp: Time.at(0), payload: "I am Heribert Innoq")
     block = Block.new(block_index: 1, timestamp: Time.at(0), proof:"1917336", previous_block_hash: 0, transactions: [transaction1])

    #  expected String does not match the one given by MArcs since we sort the members.
     expectedString = '{"index":1,"timestamp":0,"proof":1917336,"transactions":[{"id":"b3c973e2-db05-4eb5-9668-3e81c7389a6d","timestamp":0,"payload":"I am Heribert Innoq"}],"previousBlockHash":"0"}';

     assert_equal block.as_json.to_json, expectedString

   end
end
