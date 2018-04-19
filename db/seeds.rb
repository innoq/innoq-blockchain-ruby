# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Block.create(
  "block_index": 1, "timestamp": Time.at(0), "proof": 1917336,
  "transactions_attributes": [
    {"transaction_id": "b3c973e2-db05-4eb5-9668-3e81c7389a6d", "timestamp": Time.at(0), "payload": "I am Heribert Innoq"}
  ],
  "previous_block_hash": "0"
)
