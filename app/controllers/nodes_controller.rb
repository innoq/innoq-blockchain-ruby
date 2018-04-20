require 'net/http'

class NodesController < ApplicationController
  before_action :set_node, only: %i[show edit update destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show; end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit; end

  def register; end

  def sync
    @node = Node.find(params[:id])
    @blocks = parse_blocks fetch_blocks(@node)
    ours = Chain.new(Block.all)
    theirs = Chain.new(@blocks)
    if theirs.is_hash_valid?
      merged = ours.merge theirs
      logger.info merged
      message = merged ? 'Our Chain was successfully synced from Node.' : 'Our Chain is up to date.'
      render :show, notice: 'message'
    else
      render :show, alert: 'Node had invalid chain.'
    end
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
        Event.post_new_node(@node)

        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_node
    @node = Node.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def node_params
    params.require(:node).permit(:available, :host, :node_id)
  end

  def parse_blocks(chain_data)
    blocks_data = chain_data['blocks']
    blocks = []
    blocks_data.each do |block|
      block['block_index'] = block.delete('index')
      block['previous_block_hash'] = block.delete('previousBlockHash')
      block['timestamp'] = Time.at(block.delete('timestamp'))
      transactions = parse_transactions block.delete('transactions')
      new_block = Block.new(block)
      new_block.transactions = transactions
      blocks << new_block
    end
    blocks
  end

  def parse_transactions(transactions_data)
    transactions = []
    transactions_data.each do |transaction|
      transaction['transaction_id'] = transaction.delete('id')
      transaction['timestamp'] = Time.at(transaction.delete('timestamp'))
      transactions << Transaction.new(transaction)
    end
    transactions
  end

  def fetch_blocks(node)
    uri = URI.parse("#{node.host}/blocks")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header('Accept' => 'application/json')
    response = http.request(request)
    data = response.body
    JSON.parse(data)
  end
end
