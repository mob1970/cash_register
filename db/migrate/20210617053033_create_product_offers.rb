class CreateProductOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :product_offers do |t|
      t.references :product, foreign_key: true
      t.integer :minimum_quantity
      t.decimal :new_price, precision: 10, scale: 3

      t.timestamps
    end
  end
end
