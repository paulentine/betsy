require "test_helper"

describe Order do
  let(:order) { Order.new }

  it "must be valid" do
    value(order).must_be :valid?
  end






  describe "last 4 cc number" do
    it "returns the correct numbers" do
      Order.last4_ccnum("5663494509345")
      
    end

    it "returns the cc_num if it shorter than 4 chars" do

    end

    it "returns nil if no parameter is given" do
      Order.last4_ccnum().must_return_nil
    end
  end

  describe "validations" do
    before do
      @merchant = Merchant.new(username: "Katie_Finch", email: "katie@gmail.com", uid: 34546, provider: "github")
      @product = Product.new(id: 10, name: "John", price: 2.0, quantity: 3)
      @order_item = OrderItem.new(quantity: 1, order_id: 4, product_id: 10)
      @order = Order.new(
        id: 4,
        email: "julie@gmail.com",
        name: "Julie Taylor",
        address: "6805 De Paul Cove, Austin, Texas",
        zipcode: "78723",
        cc_num: "17285678",
        cc_cvv: "455",
        cc_expiration: "06/13/22",
        order_item: 1
      )
    end
    describe "validations" do
      it "passes validations with good data" do
        expect(@order).must_be :valid?
      end

      it "rejects orders without a order item" do
        @order.order_item = nil
        result = @order.valid?
  
        # assert
        expect(result).must_equal false
        expect(@order.errors.messages).must_include :order_item
      end
    end
  end

end
