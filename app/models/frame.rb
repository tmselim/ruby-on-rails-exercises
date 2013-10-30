class Frame < ActiveRecord::Base
  belongs_to :brand
  has_many :orders
end
