class BlocksController < ApplicationController
  def index
    # lade alles auder db
    @blocks = Block.all
    respond_to do |format|
      format.html { render :index}
      format.json {
        render json: "{ \"blocks\": [" + @blocks.map(&:as_json).join(",") + "] }"
      }
    end

    # schicke an view
  end

  def show
    @block = Block.find(params[:id])
    respond_to do |format|
      format.html { render :show}
      format.json {
        render json: @block.as_json
      }
    end
  end
end
