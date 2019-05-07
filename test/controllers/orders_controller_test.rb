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


  describe "create" do
    it "creates a new order" do
      order_data = {
        order: {
          email: "matt@gmail.com",
          name: "Matt Saracen",
          address: "3009 Kuhlman Ave., Austin, Texas",
          zipcode: "78702",
          cc_num: "10987654321",
          cc_cvv: "689",
          cc_expiration: "06/25/21",
        },
      }

      # Act
      expect {
        post orders_path, params: order_data
      }.must_change "Order.count", +1

      order = Order.last
      must_respond_with :redirect
      must_redirect_to order_confirmation_path(order)

      check_flash

      expect(order.email).must_equal order_data[:order][:email]
      expect(order.name).must_equal order_data[:order][:name]

    end

    it "sends back bad_request if no order data is sent" do
      order_data = {
        order: {
            email: "",
            name: "",
            address: "",
            zipcode: "",
            cc_num: "",
            cc_cvv: "",
            cc_expiration: "",
        },
      }
      expect(Order.new(order_data[:order])).wont_be :valid?

      # Act
      expect {
        post orders_path, params: order_data
      }.wont_change "Order.count"

      # Assert
      must_respond_with :bad_request

      check_flash(:error)
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
    end

    describe "show" do
      it "can get a valid order" do
        tim = orders(:order1)
        get order_path(tim.id)

        # Assert
        must_respond_with :success
      end

      it "will redirect for an invalid order" do
        order_id = 12345
        # Act
        get order_path(order_id)

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


  # describe "validations" do
  #   before do
  #     @merchant = Merchant.new(username: "Katie_Finch", email: "katie@gmail.com", uid: 34546, provider: "github")
  #     @product = Product.new(id: 10, name: "John", price: 2.0, quantity: 3)
  #     @order_item = OrderItem.new(quantity: 1, order_id: 4, product_id: 10)
  #     @order = Order.new(
  #       id: 4,
  #       email: "julie@gmail.com",
  #       name: "Julie Taylor",
  #       address: "6805 De Paul Cove, Austin, Texas",
  #       zipcode: "78723",
  #       cc_num: "17285678",
  #       cc_cvv: "455",
  #       cc_expiration: "06/13/22",
  #       order_item: 1
  #     )
  #   end
  #   describe "validations" do
  #     it "passes validations with good data" do
  #       expect(@order).must_be :valid?
  #     end

  #     it "rejects orders without a order item" do
  #       @order.order_item = nil
  #       result = @order.valid?
  
  #       # assert
  #       expect(result).must_equal false
  #       expect(@order.errors.messages).must_include :order_item
  #     end
  #   end
  # end

end
