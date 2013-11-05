class Brand < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :frames
  has_many :orders, through: :frames
end
