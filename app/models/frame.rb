class Frame < ActiveRecord::Base
  validates :name, :brand_id, presence: true
  
  belongs_to :brand
  has_many :orders
end
