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
product_failures = []
CSV.foreach(product_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  
  product = Product.new(data)
  
  successful = product.save
  
  
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    # puts "Created product: #{product.inspect}"
  end
end

categoryproduct_failures = []
categories_products = Rails.root.join("db", "categories_products.csv")
CSV.foreach(categories_products, :headers => true, header_converters: :symbol, converters: :all) do |row|
  product = Product.find_by(id: row[:product_id])
  category = Category.find_by(id: row[:category_id])
  
  if category && product 
    product.category_ids = product.category_ids << category.id
    successful = product.save
  end 
  
  if !successful
    categoryproduct_failures << product
    puts "Failed to add a category to product: #{product.inspect}"
  else
    # puts "Added a category to product: #{product.inspect}"
  end
end

reviews_file = Rails.root.join("db", "reviews_seeds.csv")

CSV.foreach(reviews_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Review.create!(data)
end