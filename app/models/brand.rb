class Brand < ActiveRecord::Base
  has_many :frames
  has_many :orders, through: :frames
end
