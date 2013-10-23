class AddBrandToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :brand_id, :reference
  end
end
