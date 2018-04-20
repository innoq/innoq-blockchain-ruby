class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transactions_params)
    @transaction.timestamp = Time.now
    @transaction.transaction_id = SecureRandom.uuid

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path, notice: 'Transaction erfolgreich angelegt.' }
        # format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, alert: 'Transaction nicht gespeichert.' }
        # format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def transactions_params
    params.require(:transaction).permit(:payload)
  end
end
