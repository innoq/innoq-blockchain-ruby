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
  end
end
