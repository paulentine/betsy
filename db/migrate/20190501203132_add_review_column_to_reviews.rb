class AddReviewColumnToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :review, :string
  end
end
