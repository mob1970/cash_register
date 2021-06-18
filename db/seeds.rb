# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
Product.create([
  { code: 'GR1', name: 'Green Tea', price: 3.11 },
  { code: 'SR1', name: 'Strawberries', price: 5.00 },
  { code: 'CF1', name: 'Coffee', price: 11.23 }
])

ProductOffer.create([
  { product_id: 1, minimum_quantity: 1, new_price: 0.00 },
  { product_id: 2, minimum_quantity: 3, new_price: 4.50 },
  { product_id: 3, minimum_quantity: 3, new_price: 7.486 }
])
