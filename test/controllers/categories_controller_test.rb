require "test_helper"

describe CategoriesController do
  # it "should get index" do
  #   post categories_index_url
  #   value(response).must_be :success?
  # end


  describe "Logged in user" do
    before do
      @merchant = perform_login
    end

    describe "index" do
      it "succeeds when there are categories" do
        get categories_path

        must_respond_with :success
      end

      it "succeeds when there are no categories" do
        Category.all do |work|
          category.destroy
        end

        get categories_path

        must_respond_with :success
      end
    end

    describe "new" do
      it "retruns status code 200" do
        get new_category_path
        must_respond_with :ok
      end
    end

    describe "create" do
      it "creates a new category" do
        category_data = {
          category: {
            category: "My Category",
          },
        }

        expect {
          post categories_path, params: category_data
        }.must_change "Category.count", +1

        new_category = Category.last

        must_respond_with :redirect
        must_redirect_to categories_path

        check_flash

        expect(new_category.category).must_equal category_data[:category][:category]
      end

      it "sends back bad_request if no category data is sent" do
        category_data = {
          category: {
            category: nil,
          },
        }
        expect(Category.new(category_data[:category])).wont_be :valid?

        expect {
          post categories_path, params: category_data
        }.wont_change "Category.count"

        must_respond_with :bad_request

        check_flash(:error)
      end
    end





  end

  describe "guest users" do
    it "requires login for new" do
      get new_category_path

      must_respond_with :redirect
      must_redirect_to login_path
    end

    it "requires login for create" do
      category_data = {
        category: {
          category: "this is a new category",
        },
      }

      expect {
        post categories_path, params: category_data
      }.wont_change "Category.count"

      must_respond_with :redirect
      must_redirect_to login_path
    end
  end
end
