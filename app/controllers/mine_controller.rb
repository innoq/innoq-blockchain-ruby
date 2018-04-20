class MineController < ApplicationController
  def mine
    new_block = nil
    @time = Benchmark.realtime do
      new_block = Miner.new.new_mine
    end
    @block = new_block
    respond_to do |format|
      format.html { render :mine }
      format.json do
        render json:
        {
          message: 'done',
          block: @block
        }
      end
    end
  end
end
