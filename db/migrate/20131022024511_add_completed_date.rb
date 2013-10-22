class AddCompletedDate < ActiveRecord::Migration
  def change
    add_column :orders, :completed_on, :datetime
  end
end
