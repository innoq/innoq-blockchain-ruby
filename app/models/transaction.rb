class Transaction < ApplicationRecord
  belongs_to :block

  default_scope { order(timestamp: :asc )}
  def as_json()
    "{\"id\":\"#{transaction_id}\",\"timestamp\":#{timestamp.to_i},\"payload\":\"#{payload}\"}"
  end
end
