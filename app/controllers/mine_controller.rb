class MineController < ApplicationController
  def mine
    previous = Block.first
    @block = Miner.new.mine_with_previous(previous)
    @block.save

    respond_to do |format|
      format.html { render :minde}
      format.json {
        render json: "{\"message\" : \"done\", \"block\" : #{@block.as_json} } "
      }
    end
  end
end
