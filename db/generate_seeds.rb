require "faker"
require "csv"
CSV.open("../db/merchant_seeds.csv", "w", :write_headers => true, :headers => ["provider", "email", "username", "uid"]) do |csv|
  20.times do
    provider = "github"
    email = Faker::Internet.email
    username = (Faker::Creature::Cat.name).downcase + rand(0..100).to_s
    csv << [provider, email, username]
  end
end
