class Event < ApplicationRecord
  validates :event, :data, presence: true

  default_scope { order(:created_at) }
  scope :since, ->(t) { where('created_at >= ?', t) }

  class << self

    def post_new_block(block)
      Event.create!(event: 'new block', data: block.to_json)
    end

    def post_new_transation(transaction)
      Event.create!(event: 'new transaction', data: transaction.to_json)
    end

    def post_new_node(node)
      Event.create!(event: 'new node', data: node.to_json)
    end
  end


  def to_sse
    "id: #{id}\n" +
      "event: #{event}\n" +
      "data: #{data}\n\n"
  end
end
