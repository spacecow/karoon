Factory.define :book do |f|
end

Factory.define :user do |f|
  f.email 'test@example.com'
  f.password 'secret'
end
