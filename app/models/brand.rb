class Brand < ActiveRecord::Base
  has_many :orders
end
