class Transaction < ApplicationRecord
  belongs_to :block


  def as_json()
    "{\"id\":\"#{transaction_id}\",\"timestamp\":#{timestamp.to_i},\"payload\":\"#{payload}\"}"
  end
end
