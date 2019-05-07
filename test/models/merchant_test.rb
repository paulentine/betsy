require "test_helper"

describe Merchant do
  before do
    @merchant = merchants(:merchant1)
  end
  
  describe "Validation" do
    it "Must be valid with good data" do
      expect(@merchant).must_be :valid?
    end

    it "Raises an error when creating user without username" do
      merchant = Merchant.new(
        username: nil,
      )
    end

    it "Raises an error if username is not unique" do
      # arrange
      duplicate_name = @merchant.username

      merchant = Merchant.new(
        username: duplicate_name,
      )

      # act
      result = merchant.valid?

      # assert
      expect(result).must_equal false
      expect(merchant.errors.messages).must_include :username
    end
  end

  describe "Relations" do
    it "Has products" do
    # Arrange: Load products, merchant starts with 0 product
    @merchant.products.count.must_equal 0
    product = products(:product1)

    # Act: Assign product to merchant
    @merchant.products << product

    # Assert: Check products count & attr
    @merchant.products.last.name.must_equal product.name
    @merchant.products.last.price.must_equal product.price
    @merchant.products.last.merchant.must_equal @merchant
    @merchant.products.last.quantity.must_equal product.quantity
    end
  end
end
