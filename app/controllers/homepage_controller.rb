class HomepageController < ApplicationController
  def show
    @unpaid_order_count = Order.unpaid.count
    @unfinished_order_count = Order.unfinished.count
  end
end
