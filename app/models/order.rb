class Order < ActiveRecord::Base
  validates :customer_name, :customer_email, :description, :price, presence: true
  scope :unpaid, -> { where("paid_for_on is null") }
end
