require "test_helper"

describe ReviewsController do
  describe "create" do
    it "creates a new review" do
      review_data = {
        review: {
          review: "My review",
          rating: 5,
          product_id: products(:product1).id
        },
      }

      expect {
        post product_reviews_path(products(:product1)), params: review_data
      }.must_change "Review.count", +1

      new_review = Review.last

      must_respond_with :redirect
      must_redirect_to product_path(new_review.id)

      check_flash

      expect(new_review.review).must_equal review_data[:review][:review]
      expect(new_review.rating).must_equal review_data[:review][:rating]
    end

    it "sends back bad_request if no product data is sent" do
      review_data = {
        review: {
          rating: "",
        },
      }
      expect(Review.new(review_data[:review])).wont_be :valid?

      expect {
        post product_reviews_path(products(:product1)), params: review_data
      }.wont_change "Review.count"

      must_respond_with :bad_request

      check_flash(:error)
    end
  end
end
