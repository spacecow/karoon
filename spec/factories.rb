Factory.define :author do |f|
end

Factory.define :book do |f|
  f.sequence(:title){|n| "Factory Title #{n}"}
  f.regular_price 1000
  f.sequence(:category_tokens){|n| "token#{n}"}
end

Factory.define :cart do |f|
end

Factory.define :category do |f|
  f.name 'Factory name'
end

Factory.define :line_item do |f|
  f.association :book
end

Factory.define :order do |f|
  f.name 'Factory Name'
  f.address 'Factory Address'
  f.email 'Factory Email'
  f.pay_type 'Purchase Order'
end

Factory.define :search do |f|
  f.keywords 'Factory Keywords'
  f.ip '1.2.3.4'
end

Factory.define :user do |f|
  f.email 'test@example.com'
  f.password 'secret'
end
