require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
   test "Products attributes must not be empty" do
     product =Product.new
     assert product.invalid?
     assert product.errors[:title].any?
     assert product.errors[:description].any?
     assert product.errors[:image_url].any?
     assert product.errors[:price].any?
   end
   
   test "Product price must be positive" do
     product = Product.new(
       title: "Title",
       description: "description",
       image_url: 'xxx.png'
     )
     product.price = -1
     assert product.invalid?
     assert_equal "must be greater than or equal to 0.1",
     product.errors[:price].join('; ')
     product.price = 0
     assert product.invalid?
     assert_equal "must be greater than or equal to 0.1",
     product.errors[:price].join('; ')
     product.price = 1
     assert product.invalid?
   end
   
   def new_product(image_url)
     product = Product.new(
     title: "New Title",
     description: "New description",
     price: 1,
     image_url: image_url)
   end
   
   test "Image URL" do
     ok = %w{ ok.jpg OK.jpg OK.JPG ok.JPG oK.png ok.PNG http://www.site.com/dir1/dir2/of.gif /dir/dir/ok.GIF}
     bad = %w{ bad.doc bad.DOC BAD.sys bad.bat bad.js}
   
     ok.each do |image_url|
       assert new_product(image_url).invalid?, "#{image_url} shouldn't be invalid"
     end
   
     bad.each do |image_url|
       assert new_product(image_url).invalid?, "#{image_url} shouldn't be valid"
     end
   end
   
   test "Product is not valid without unique title" do
     product = Product.new( title: products(:ruby_book).title,
     description: "any words",
     price: 10,
     image_url: "zzz.jpg")
     
     assert !product.save
     assert_equal "has already been taken", product.errors[:title].join('; ')
   end
end
