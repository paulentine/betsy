require "test_helper"

describe MerchantsController do
  describe "auth callback" do
    it "can log in an existing user" do
      # Arrange
      merchant = merchants(:merchant1)

       # Act
      expect {
        perform_login(merchant)
      }.wont_change "Merchant.count"

       # Assert
      expect(session[:merchant_id]).must_equal merchant.id
      must_redirect_to root_path
    end
  end

  describe "current" do
    it "responds with 302 Found for a logged-in merchant" do
      # Arrange
      perform_login

      # Act
      get current_merchant_path

      # Assert
      must_respond_with :found
    end
  end
end
