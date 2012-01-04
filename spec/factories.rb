Factory.define :author do |f|
end

Factory.define :book do |f|
  f.title 'Factory Title'
end

Factory.define :user do |f|
  f.email 'test@example.com'
  f.password 'secret'
end
