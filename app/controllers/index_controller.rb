
class IndexController < ApplicationController
  def index
    @node_id = "ruby" + ENV['USER']
    @block_height = Block.all.count
    respond_to do |format|
      format.html { render :index}
      format.json {
        render json: {
          nodeId: @node_id,
          currentBlockHeight: @block_height
        }
      }
    end
  end

end
