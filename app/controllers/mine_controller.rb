class MineController < ApplicationController
  def mine
    previous = Block.first
    @block = Miner.new.mine_with_previous(previous)
    @block.save
  end
end
