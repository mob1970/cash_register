class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :code, limit: 10
      t.string :name, limit: 50
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
