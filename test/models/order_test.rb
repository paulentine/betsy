require "test_helper"

describe Order do
  # let(:order) { Order.new }
  
  describe "validations" do
    before do
      # @merchant = merchants(:merchant1)
      @product = products(:product1)
      # @order_item = order_items(:oi1)
      # @order = orders(:order1)
      
      # @order_item = OrderItem.create(
      #   quantity: 1,
      #   product_id: @product
      #   )   

      @order = Order.create(
        email: "julie@gmail.com",
        name: "Julie Taylor",
        address: "6805 De Paul Cove, Austin, Texas",
        zipcode: "78723",
        cc_num: "17285678",
        cc_cvv: "455",
        cc_expiration: "06/13/22"
      )      
        # @order.order_items << @order_item
      # @merchant = Merchant.new(username: "Katie_Finch", email: "katie@gmail.com", uid: 34546, provider: "github")
      # @product = Product.new(id: 10, name: "John", price: 2.0, quantity: 3)
      # @order_item = OrderItem.new(quantity: 1, order_id: 4, product_id: 10)
    end
    
    it "passes validations with good data" do
      result = @order.valid?
      expect(result).must_equal true
    end

    it "rejects orders without an email" do
      @order.email = nil
      @order.save
      result = @order.valid?

      expect(result).must_equal false
      expect(@order.errors.messages).must_include :email
    end

    it "rejects orders without an name" do
      @order.name = nil
      @order.save
      result = @order.valid?


      expect(result).must_equal false
      expect(@order.errors.messages).must_include :name
    end
  end

  describe "last 4 cc number" do
    it "returns the correct numbers" do
      expect(Order.last4_ccnum("12345678910")).must_equal "8910"
    end

    it "returns the cc_num if it's shorter than 4 chars" do
      expect(Order.last4_ccnum("12")).must_equal "12"
    end

    it "returns nil if no parameter is given" do
      Order.last4_ccnum(nil).must_be_nil
    end
  end

  describe "total_revenue" do
   


    it "returns the correct" do
      merchant = merchants(:merchant1)

      puts Order.total_revenue(merchant)
    end
  end
end

