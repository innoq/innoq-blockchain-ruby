class Transaction < ApplicationRecord
  belongs_to :block

  default_scope { order(timestamp: :asc )}

  scope :open, -> {
    where(block_id: nil)
  }

  # def as_json()
  #   "{\"id\":\"#{transaction_id}\",\"timestamp\":#{timestamp.to_i},\"payload\":\"#{payload}\"}"
  # end

  def to_builder
    Jbuilder.new do |json|
      json.id transaction_id
      json.timestamp  timestamp.to_i
      json.payload payload
    end
  end
end
