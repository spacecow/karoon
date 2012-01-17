Factory.define :author do |f|
end

Factory.define :book do |f|
  f.title 'Factory Title'
  f.regular_price 1000
  f.sequence(:category_tokens){|n| "token#{n}"}
end

Factory.define :category do |f|
  f.name 'Factory name'
end

Factory.define :search do |f|
end

Factory.define :user do |f|
  f.email 'test@example.com'
  f.password 'secret'
end
