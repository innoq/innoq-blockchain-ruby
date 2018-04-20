class MineController < ApplicationController
  def mine
    @block = Miner.new.new_mine
    Event.post_new_block(@block)

    respond_to do |format|
      format.html { render :mine}
      format.json {
        render json:
        {
          message: "done",
          block: @block
        }
      }
    end
  end
end
