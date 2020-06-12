require "csv"

category_file = Rails.root.join("db", "category_seeds.csv")

CSV.foreach(category_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Category.create!(data)
end

merchant_file = Rails.root.join("db", "merchant_seeds.csv")

CSV.foreach(merchant_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Merchant.create!(data)
end

product_file = Rails.root.join("db", "product_seeds.csv")

CSV.foreach(product_file, headers: true, header_converters: :symbol, converters: :all) do |row|
    data = Hash[row.headers.zip(row.fields)]
    puts data
    Product.create!(data)
end

