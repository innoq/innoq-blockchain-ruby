class BlocksController < ApplicationController
  def index
    @blocks = Block.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: Chain.new(@blocks) }
    end
  end

  def show
    @block = Block.find(params[:id])
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @block }
    end
  end
end
