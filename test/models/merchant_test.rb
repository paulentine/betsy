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
    # Arrange: Load products

    # Act: Add products

    # Assert: Check products count & attr
    end
  end
end
