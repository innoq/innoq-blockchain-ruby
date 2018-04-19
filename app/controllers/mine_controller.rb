class MineController < ApplicationController
  def mine
    @block = Miner.new.new_mine
    respond_to do |format|
      format.html { render :mine}
      format.json {
        render json: "{\"message\" : \"done\", \"block\" : #{@block.as_json} } "
      }
    end
  end
end
