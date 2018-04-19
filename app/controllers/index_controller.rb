class IndexController < ApplicationController
  def index
    @node_id = "123456789"
    @block_height = Block.all.count

  end
end
