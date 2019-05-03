require "test_helper"

describe ProductsController do
  describe "index" do
    it "can render" do
      get products_path

      must_respond_with :ok
    end

    it "renders even if are zero products" do
      Product.destroy_all

      get products_path

      must_respond_with :ok
    end
  end

  describe "show" do
    it "returns a 404 status code the product doesn't exist" do
      product_id = "FAKE ID"

      get product_path(product_id)

      must_respond_with :not_found
    end

    it "works for a Product instance that exists" do
      product = products(:product1)
      puts product.id
      get product_path(product)

      must_respond_with :ok
    end
  end

  describe "Logged in user" do
    before do
      @merchant = perform_login
    end

    # binding.pry

    describe "new" do
      it "retruns status code 200" do
        get new_product_path
        must_respond_with :ok
      end
    end

    describe "create" do
      it "creates a new product" do
        test_merchant = merchants(:merchant1)
        product_data = {
          product: {
            name: "randommmmm",
            price: 10,
            merchant_id: test_merchant.id
          },
        }

        # Book.new(book_data[:book])
        # binding.pry

        expect {
          post products_path, params: product_data
        }.must_change "Product.count", +1

        product = Product.last

        must_respond_with :redirect
        must_redirect_to product_path(product.id)

        check_flash

        expect(product.name).must_equal product_data[:product][:name]
        expect(product.price).must_equal product_data[:product][:price]
      end

      it "sends back bad_request if no product data is sent" do
        product_data = {
          product: {
            name: "",
          },
        }
        expect(Product.new(product_data[:product])).wont_be :valid?

        expect {
          post products_path, params: product_data
        }.wont_change "Product.count"

        must_respond_with :bad_request

        check_flash(:error)
      end
    end
  end
end
