json.index @block.block_index
json.timestamp @block.timestamp.to_i
json.proof @block.proof
json.transactions @block.transactions do |transaction|
  json.partial! 'transactions/partial', transaction: transaction
end


#json.partial! 'comments/comments', comments: @message.comments
json.previousBlockHash @block.previous_block_hash
