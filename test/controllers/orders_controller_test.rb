require "test_helper"

describe OrdersController do
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
      # Act
      get work_path(-1)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get the new order page" do

      get new_order_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "returns a 404 status code if the order doesn't exist" do
      order_id = 12345

      get order_path(order_id)

      must_respond_with :not_found
    end

    it "works for a order that exists" do
      order = orders(:order1)
      get order_path(order.id)

      # Assert
      must_respond_with :ok
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

      
      must_respond_with :redirect
      must_redirect_to order_confirmation_path

      check_flash

      order = Order.last
      expect(order.email).must_equal order_data[:order][:email]
      expect(order.merchant).must_equal @merchant

    end

    it "sends back bad_request if no book data is sent" do
      book_data = {
        book: {
          title: "",
        },
      }
      expect(Book.new(book_data[:book])).wont_be :valid?

      # Act
      expect {
        post books_path, params: book_data
      }.wont_change "Book.count"

      # Assert
      must_respond_with :bad_request

      check_flash(:error)
    end
  end

  describe "edit" do
    it "responds with OK for a real book" do
      get edit_book_path(@book)
      must_respond_with :ok
    end

    it "responds with NOT FOUND for a fake book" do
      book_id = Book.last.id + 1
      get edit_book_path(book_id)
      must_respond_with :not_found
    end
  end
end
