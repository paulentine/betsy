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
      product_id = 1337

      get product_path(product_id)

      must_respond_with :not_found
    end

    it "works for a Product instance that exists" do
      product = products(:product1)

      get product_path(product)

      must_respond_with :ok
    end
  end

  describe "Logged in user" do
    before do
      @merchant = perform_login
    end

    describe "new" do
      it "retruns status code 200" do
        get new_product_path
        must_respond_with :ok
      end
    end

    describe "create" do
      it "creates a new product" do
        product_data = {
          product: {
            name: "My Product",
            price: 10.0,
          },
        }

        expect {
          post products_path, params: product_data
        }.must_change "Product.count", +1

        new_product = Product.last

        must_respond_with :redirect
        must_redirect_to product_path(new_product.id)

        check_flash

        expect(new_product.name).must_equal product_data[:product][:name]
        expect(new_product.price).must_equal product_data[:product][:price]
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

    describe "edit" do
      it "responds with OK for a real product" do
        get edit_product_path(products(:product1))
        must_respond_with :ok
      end

      it "responds with NOT FOUND for a fake product" do
        product_id = "FAKE ID"
        get edit_product_path(product_id)
        must_respond_with :not_found
      end

      it "doesn't allow a merchant to edit a product if it is not theirs" do
        product_data = {
          product: {
            name: "product to be edited",
            price: 10,
            merchant_id: Merchant.last.id,
          },
        }
        product = Product.create(product_data[:product])

        expect {
          get edit_product_path(product)
        }.wont_change "Product.count"

        check_flash(:error)

        must_respond_with :redirect
        must_redirect_to product_path(product)

        product.reload

        product.deleted.must_equal false
      end







    end

    describe "update" do
      let(:product_data) {
        {
          product: {
            name: "changed and new",
          },
        }
      }

      let(:product) { products(:product1) }
      # binding.pry
      it "changes the data on the model" do
        # product = Product.create!(name: "test product", price: 10.00)
        product.assign_attributes(product_data[:product])
        expect(product).must_be :valid?
        product.reload

        # Act
        patch product_path(product), params: product_data

        # Assert
        must_respond_with :redirect
        must_redirect_to product_path(product)

        check_flash

        product.reload
        expect(product.name).must_equal(product_data[:product][:name])
      end

      it "responds with NOT FOUND for a fake product" do
        product_id = "FAKE ID"
        patch product_path(product_id), params: product_data
        must_respond_with :not_found
      end

      it "responds with BAD REQUEST for bad data" do
        # Arrange
        product_data[:product][:name] = ""

        # Assumptions
        product.assign_attributes(product_data[:product])
        expect(product).wont_be :valid?
        product.reload

        # Act
        patch product_path(product), params: product_data

        # Assert
        must_respond_with :bad_request

        check_flash(:error)
      end
    end

    describe "destroy" do
      it "mark product as deleted when the product belongs to the current merchant" do
        product_data = {
          product: {
            name: "product to be deleted",
            price: 10,
            merchant_id: Merchant.first.id,
          },
        }
        product = Product.create(product_data[:product])

        # product.destroy
        # product.save

        expect {
          delete product_path(product)
        }.wont_change "Product.count"

        check_flash

        must_respond_with :redirect
        must_redirect_to merchant_path(Merchant.first)

        product.reload
        expect(product.deleted).must_equal true
      end

      it "doesn't allow a merchant to delete a product if it is not theirs" do
        product_data = {
          product: {
            name: "product to be deleted",
            price: 10,
            merchant_id: Merchant.last.id,
          },
        }
        product = Product.create(product_data[:product])

        expect {
          delete product_path(product)
        }.wont_change "Product.count"

        check_flash(:error)

        must_respond_with :redirect
        must_redirect_to product_path(product)

        product.reload

        product.deleted.must_equal false
      end
    end
  end

  describe "guest users" do
    it "requires login for new" do
      get new_product_path

      must_respond_with :redirect
      must_redirect_to login_path
    end

    it "requires login for create" do
      product_data = {
        product: {
          name: "this is a new product",
          price: 10.00,
        },
      }

      expect {
        post products_path, params: product_data
      }.wont_change "Product.count"

      must_respond_with :redirect
      must_redirect_to login_path
    end

    it "requires login for edit" do
      get edit_product_path(Product.first)

      must_respond_with :redirect
      must_redirect_to login_path
    end

    it "requires login for update" do
      old_product = Product.first.name
      product_data = {
        product: {
          name: old_product + " an edit",
          price: 10.00,
        },
      }

      patch product_path(Product.first), params: product_data

      expect(Product.first.name).must_equal old_product
      must_respond_with :redirect
      must_redirect_to login_path
    end

    it "requires login for delete" do
      expect {
        delete product_path(Product.first)
      }.wont_change "Product.count"
      must_respond_with :redirect
      must_redirect_to login_path
    end
  end
end
