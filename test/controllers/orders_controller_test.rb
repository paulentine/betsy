require "test_helper"

describe OrdersController do
  before do
    @merchant = Merchant.first
  end

  describe "session has order id" do
    it "add to cart creates a new order if session[:order_id] is empty" do
      order_item_hash = {
        order_item: {
          product_id: Product.last.id,
          quantity: 1,
        },
      }
      expect {
        post order_items_path, params: order_item_hash
      }.must_change 'Order.count', 1

      expect(session[:order_id]).must_equal Order.last.id
    end

    it "accesses the correct order if session has order_id" do
      order_item_hash = {
        order_item: {
          product_id: Product.first.id,
          quantity: 1,
        },
      }

      expect {
        post order_items_path, params: order_item_hash
      }.must_change 'Order.count', 1
      
      expect(session[:order_id]).must_equal Order.last.id
      
      # Adding another order item to this order won't change Order count
      order_item_two = {
        order_item: {
          product_id: Product.last.id,
          quantity: 1,
        },
      }

      expect {
        post order_items_path, params: order_item_two
      }.wont_change 'Order.count'

      expect(session[:order_id]).must_equal Order.last.id
    end
  end

  describe "new" do
    it "returns status code 200" do
      get new_order_path
      must_respond_with :ok
    end
  end

  describe "checkout" do
    it "redirect to confirmation page after checkout" do
      @current_order = Order.new
      order_params = {
        order: {
          email: "james.gmail.com",
          name: "Jesse James",
          address: "465 Prince St.",
          zipcode: "10128",
          cc_num: "2345786",
          cc_cvv: "456",
          cc_expiration: "8/20",
        }
      }
      patch checkout_path(@current_order.id)

      must_redirect_to confirmation_path(Order.last.id)
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
    describe "index" do
      it "can get index" do
        get orders_path

        must_respond_with :success
      end

      it "returns a 404 error if merchant is not found" do

        @current_merchant = Merchant.find_by(id: 565)
        get orders_path

        must_respond_with :not_found
      end

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

  describe "guest users" do
    it "requires login for index" do
      get merchant_orders_path(@merchant.id)
      must_redirect_to login_path
    end

    it "requires login for show" do
      get merchant_order_path(id: Order.first.id, merchant_id: @merchant.id)
      must_redirect_to login_path
    end
  end
  
end
