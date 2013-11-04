require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'order can save' do
    order = FactoryGirl.build(:order)
    assert order.save
  end

  test 'order requires customer name' do
    order = FactoryGirl.build(:order, customer_name: nil)
    assert !order.save, "Saved the order without customer_name"
  end
end
