class OrdersBelongToFrames < ActiveRecord::Migration
  def change
    remove_reference :orders, :brand
    add_reference :orders, :frame
  end
end
