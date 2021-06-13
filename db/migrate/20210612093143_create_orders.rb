class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :name, limit: 50
      t.decimal :total_amount, precision: 15, scale: 2

      t.timestamps
    end
  end
end
