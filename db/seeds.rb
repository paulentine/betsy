require "csv"

# CATEGORIES

input_categories = Rails.root.join("db", "", "category_seeds.csv")
puts "Loading raw category data from #{input_categories}"

category_failures = []

CSV.foreach(input_categories, :headers => true) do |row|
  category = Category.new
  category.category = row["category"]

  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save media: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} category failed to save"

# PRODUCTS

input_products = Rails.root.join("db", "", "product_seeds.csv")
puts "Loading raw product data from #{input_products}"

product_failures = []

CSV.foreach(input_products, :headers => true) do |row|
  product = Product.new
  product.name = row["name"]
  product.price = row["price"]
  product.merchant_id = row["merchant_id"]
  product.quantity = row["quantity"]
  product.description = row["description"]
  product.photo_url = row["photo_url"]

  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save"

# MERCHANTS

input_merchants = Rails.root.join("db", "", "merchant_seeds.csv")
puts "Loading raw merchant data from #{input_merchants}"

merchant_failures = []

CSV.foreach(input_merchants, :headers => true) do |row|
  merchant = Merchant.new
  merchant.username = row["username"]
  merchant.email = row["email"]
  merchant.uid = row["uid"]
  merchant.provider = row["provider"]

  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save media: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchant failed to save"

# REMAINING

input_orders = [
  {
    email: "tim@gmail.com",
    name: "Tim Riggins",
    address: "7252 Burleson Manor Rd., Manor, Texas",
    zipcode: "80435",
    cc_num: "12345678910",
    cc_cvv: "435",
    cc_expiration: "08/19/20",
    status: "pending",
  },
  {
    email: "matt@gmail.com",
    name: "Matt Saracen",
    address: "3009 Kuhlman Ave., Austin, Texas",
    zipcode: "78702",
    cc_num: "10987654321",
    cc_cvv: "689",
    cc_expiration: "06/25/21",
    status: "pending",
  },
]
# input_categories = [
#   {
#     category: "Tour",
#   },
#   {
#     category: "Food",
#   },
# ]

input_order_items = [
  {
    quantity: 2,
    order_id: 1,
    product_id: 1,
  },
  {
    quantity: 1,
    order_id: 2,
    product_id: 2,
  },
]

input_reviews = [
  {
    rating: 2,
    review: "Boring and too long",
    product_id: 1,
  },
  {
    rating: 5,
    review: "Delicious cheese!",
    product_id: 2,
  },
]

orders_failures = []
input_orders.each do |input_order|
  order = Order.new(email: input_order[:email], name: input_order[:name], address: input_order[:address], zipcode: input_order[:zipcode], cc_num: input_order[:cc_num], cc_cvv: input_order[:cc_cvv], cc_expiration: input_order[:cc_expiration])
  successful = order.save
  if successful
    puts "Created order: #{order.inspect}"
  else
    orders_failures << order
    puts "Failed to save order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{orders_failures.length} orders failed to save"

order_items_failures = []
input_order_items.each do |input_order_item|
  order_item = OrderItem.new(quantity: input_order_item[:quantity], order_id: input_order_item[:order_id], product_id: input_order_item[:product_id])
  successful = order_item.save
  if successful
    puts "Created order_items: #{order_item.inspect}"
  else
    order_items_failures << order_item
    puts "Failed to save order_item: #{order_item.inspect}"
  end
end

puts "Added #{OrderItem.count} order_item records"
puts "#{order_items_failures.length} order_items failed to save"

reviews_failures = []
input_reviews.each do |input_review|
  review = Review.new(rating: input_review[:rating], product_id: input_review[:product_id], review: input_review[:review])
  successful = review.save
  if successful
    puts "Created review: #{review.inspect}"
  else
    reviews_failures << review
    puts "Failed to save review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{reviews_failures.length} reviews failed to save"
