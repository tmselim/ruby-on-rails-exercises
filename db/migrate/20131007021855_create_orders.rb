class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_email
      t.text :description
      t.string :price
      t.datetime :paid_for_on

      t.timestamps
    end
  end
end
