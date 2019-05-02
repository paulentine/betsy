input_orders = [
    {
        email: "tim@gmail.com",
        name: "Tim Riggins",
        address: "7252 Burleson Manor Rd., Manor, Texas",
        zipcode: "80435",
        cc_num: "12345678910",
        cc_cvv: "435",
        cc_expiration: "08/19/20",
    },
    {
        email: "matt@gmail.com", 
        name: "Matt Saracen",
        address: "3009 Kuhlman Ave., Austin, Texas",
        zipcode: "78702",
        cc_num: "10987654321",
        cc_cvv: "689",
        cc_expiration: "06/25/21",
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
        email: "sernea@constance.com",
        uid: "56789",
        provider: "github",
    },
  ]
  
  orders_failures = []
  input_orders.each do |input_orders|
    order = Order.new(email: input_orders[:email], name: input_orders[:name], address: input_orders[:address], zipcode: input_orders[:zipcode], cc_num: input_orders[:cc_num], cc_cvv: input_orders[:cc_cvv], cc_expiration: input_orders[:cc_expiration])
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
  input_merchants.each do |input_merchants|
    merchant = Merchant.new(username: input_merchants[:username], email: input_merchants[:email], uid: input_merchants[:uid], provider: input_merchants[:provider])
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
  