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

    it "creates a new merchant" do
      start_count = Merchant.count
      merchant = Merchant.create(username: "test_user", email: "test@user.com", uid: 99999, provider: "github")
      
      # expect {
        perform_login(merchant)
        # get '/auth/github/callback'
      # }.must_change "Merchant.count", +1
      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      # get callback_path(:github)
    
      # must_redirect_to root_path
    
      # # Should have created a new merchant
      Merchant.count.must_equal start_count + 1
    
      # # The new merchant's ID should be set in the session
      # session[:merchant_id].must_equal Merchant.last.id
    end
    
    it "flashes an error & redirects, when failing to save new user" do
      # Merchant data with bad username, to trigger failure case
      merchant = Merchant.new(username: "", email: "test@user.com", uid: 99999, provider: "github")

      expect {
        perform_login(merchant)
      }.wont_change "Merchant.count"

      check_flash(:error)

      must_redirect_to root_path
    end
  end

  describe "current" do
    it "responds with OK for a logged-in merchant" do
      # Arrange
      perform_login

      # Act
      get current_merchant_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "guest users" do
    before do
      @merchant = Merchant.first
    end

    it "requires login for show" do
      get merchant_path(@merchant.id)
      must_redirect_to login_path
    end

    it "requires login for current" do
      get current_merchant_path
      must_redirect_to login_path
    end
  end

end
