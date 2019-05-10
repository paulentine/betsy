require "test_helper"

describe CartsController do
  describe "logged in user" do
    before do
      perform_login
    end

    describe "show" do
      it "works for a Cart instance that exists" do
        order_items = orders(:order1).order_items
  
        get cart_path

        must_respond_with :ok
      end

      # it "returns a 404 status code if the cart doesn't exist" do
      #   @current_order = nil

      #   get cart_path
  
      #   must_respond_with :not_found
      # end
    end

    describe "checkout" do
      it "can make the current order an order" do
        order = orders(:order1)
        
        get cart_checkout_path

        must_respond_with :ok
      end
    end
  end
end
