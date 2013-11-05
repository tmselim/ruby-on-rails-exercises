require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  test 'brand can save' do
    brand = FactoryGirl.build(:brand)
    assert brand.save
  end

  test 'brand requires name' do
    brand = FactoryGirl.build(:brand, name: nil)
    assert !brand.save, "Saved the brand without name"
  end
end
