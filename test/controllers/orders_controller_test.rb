require "test_helper"

describe OrdersController do
  

  describe "new" do
    it "returns status code 200" do
      get new_order_path
      must_respond_with :ok
    end
  end

  describe "checkout" do
    before do
      get cart_path 
      @order = Order.last
    end

    it "redirects to confirmation page after checkout" do
      @order.update(
        email: "julie@gmail.com",
        name: "Julie Taylor",
        address: "6805 De Paul Cove, Austin, Texas",
        zipcode: "78723",
        cc_num: "17285678",
        cc_cvv: "455",
        cc_expiration: "06/13/22"
      )   
      patch checkout_path
      @order.reload
      must_redirect_to confirmation_path(@order)
      expect(@order.status).must_equal "paid"
    end

    it "redirects to the cart if the order is not valid and returns error message" do
      
      patch checkout_path(@order.id)
      @order.reload
      must_redirect_to checkout_cart_path

      expect(@order.status).must_equal "pending"
    end
  end

  describe "confirmation" do
    it "can get a valid order" do
      tim = orders(:order1)
      get confirmation_path(tim.id)

      # Assert
      must_respond_with :success
    end

    it "will return a 404 status code for invalid order" do
      order_id = 12345
      # Act
      get confirmation_path(order_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "Logged in users" do
    before do
      perform_login
    end

    describe "show" do
      it "can get a valid order" do
        tim = orders(:order1)
        get order_path(tim.id)

        # Assert
        must_respond_with :success
      end

      it "will return a 404 status code for invalid order" do
        order_id = 12345
        # Act
        get order_path(order_id)

        # Assert
        must_respond_with :not_found
      end
    end
    describe "order items order" do
      it "can get a valid order" do
        tim = orders(:order1)
        get order_items_order_path(tim.id)

        # Assert
        must_respond_with :success
      end

      it "will a 404 status code for invalid order" do
        order_id = 12345
        # Act
        get order_items_order_path(order_id)

        # Assert
        must_respond_with :not_found
      end
    end
  end
end
