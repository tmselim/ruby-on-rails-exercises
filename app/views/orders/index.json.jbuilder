json.array!(@orders) do |order|
  json.extract! order, :customer_name, :customer_email, :description, :price, :paid_for_on
  json.url order_url(order, format: :json)
end
