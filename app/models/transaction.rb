class Transaction < ApplicationRecord
  belongs_to :block, optional: true

  scope :from_oldest, -> { order(timestamp: :asc) }
  scope :from_newest, -> { order(timestamp: :desc) }

  scope :open, -> {
    where(block_id: nil)
  }

  def open?
    block_id.nil?
  end

  def processed_at
    if block
      block.timestamp
    else
      nil
    end
  end

  def to_builder
    Jbuilder.new do |json|
      json.id transaction_id
      json.timestamp timestamp.to_i
      json.payload payload
    end
  end
end
