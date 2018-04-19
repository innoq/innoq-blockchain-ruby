class BlocksController < ApplicationController
  def index
    # lade alles auder db
    @blocks = Block.all
    # schicke an view
  end

  def show
    @block = Block.find(params[:id])
  end
end
