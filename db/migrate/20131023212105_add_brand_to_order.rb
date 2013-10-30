class AddBrandToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :brand
  end
end
