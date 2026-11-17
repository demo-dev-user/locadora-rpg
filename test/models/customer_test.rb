require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "should not save customer without name" do
    customer = Customer.new
    assert_not customer.save, "Saved the customer without a name"
  end

  test "should save customer with name" do
    customer = Customer.new(name: "João Silva")
    assert customer.save, "Could not save the customer with a name"
  end
end
