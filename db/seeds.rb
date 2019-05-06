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

input_merchants = [
  {
    username: "blair_waldorf",
    email: "blair@constance.com",
    uid: "12345",
    provider: "github",
  },
  {
    username: "serena_vanderwoodsen",
    email: "serena@constance.com",
    uid: "56789",
    provider: "github",
  },
]

input_products = [
  {
    name: "Walking Tour of Pike Place Market",
    price: 100.0,
    quantity: 5,
    description: "Stroll around Pike Place Market and learn about the history of the area",
    merchant_id: 1,
  },
  {
    name: "Wine and Cheese Tasting",
    price: 200.0,
    quantity: 5,
    description: "Try local wines and cheese",
    merchant_id: 2,
  },
  {
    name: "Texas Forever Tour",
    price: 50.0,
    quantity: 3,
    description: "Tour of the Riggins farm",
    merchant_id: 1,
  },
]

input_categories = [
  {
    category: "Tour",
  },
  {
    category: "Food",
  },
]

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

merchants_failures = []
input_merchants.each do |input_merchant|
  merchant = Merchant.new(username: input_merchant[:username], email: input_merchant[:email], uid: input_merchant[:uid], provider: input_merchant[:provider])
  successful = merchant.save
  if successful
    puts "Created merchant: #{merchant.inspect}"
  else
    merchants_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchants_failures.length} merchants failed to save"

products_failures = []
input_products.each do |input_product|
  product = Product.new(name: input_product[:name], quantity: input_product[:quantity], description: input_product[:description], price: input_product[:price], merchant_id: input_product[:merchant_id])
  successful = product.save
  if successful
    puts "Created product: #{product.inspect}"
  else
    products_failures << product
    puts "Failed to save product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{products_failures.length} products failed to save"

categories_failures = []
input_categories.each do |input_category|
  category = Category.new(category: input_category[:category])
  successful = category.save
  if successful
    puts "Created category: #{category.inspect}"
  else
    categories_failures << category
    puts "Failed to save category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{categories_failures.length} categories failed to save"

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