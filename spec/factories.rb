FactoryGirl.define :author

FactoryGirl.define :book do |f|
  f.sequence(:title){|n| "FactoryGirl Title #{n}"}
  f.regular_price 1000
  f.sequence(:category_tokens){|n| "token#{n}"}
end

FactoryGirl.define :cart

FactoryGirl.define :category do |f|
  f.name 'factory'
end

FactoryGirl.define :line_item do |f|
  f.association :book
end

FactoryGirl.define :locale do |f|
  f.name 'FactoryGirl Name'
end

FactoryGirl.define :order do |f|
  f.name 'FactoryGirl Name'
  f.address 'FactoryGirl Address'
  f.email 'FactoryGirl Email'
  f.pay_type Order::PAY_ON_DELIVERY
  f.postal_service Order::FLYING_CARPET
end

FactoryGirl.define :search do |f|
  f.keywords 'FactoryGirl Keywords'
  f.ip '1.2.3.4'
end

FactoryGirl.define :user do |f|
  f.email 'test@example.com'
  f.password 'secret'
end
