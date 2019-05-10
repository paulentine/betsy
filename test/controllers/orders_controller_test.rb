require "test_helper"

describe OrdersController do
  before do
    @merchant = Merchant.first
  end

  describe "new" do
    it "can get the new order page" do

      get new_order_path

      must_respond_with :success
    end
  end

  describe "confirmation" do
    it "can get a valid order" do
      tim = orders(:order1)
      get order_confirmation_path(tim.id)

      # Assert
      must_respond_with :success
    end

    it "will a 404 status code for invalid order" do
      order_id = 12345
      # Act
      get order_confirmation_path(order_id)

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

      it "renders even if there are no orders" do
        # Arrange
        Order.destroy_all

        # Act
        get orders_path

        # Assert
        must_respond_with :success
      end

      it "returns a 404 error if merchant is not found" do

        @current_merchant = nil
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

      it "will a 404 status code for invalid order" do
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
