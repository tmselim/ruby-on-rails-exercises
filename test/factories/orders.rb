FactoryGirl.define do
  factory :order do
    customer_name 'Sally Jones'
    customer_email 'sally@jones.com'
    description 'Fancy orders'
    price 100
    frame
  end
end
