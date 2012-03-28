FactoryGirl.define do
  factory :author do
  end

  factory :book do
    sequence(:title){|n| "Factory Title #{n}"}
    regular_price 1000
    sequence(:category_tokens_en){|n| "token#{n}"}
  end

  factory :cart do 
  end

  factory :category do
  end

  factory :line_item do
    association :book
  end

  factory :locale do
    name 'Factory Name'
  end

  factory :order do
    name 'Factory Name'
    address 'Factory Address'
    email 'Factory Email'
    pay_type Order::PAY_ON_DELIVERY
    postal_service Order::FLYING_CARPET
  end

  factory :search do
    keywords 'Factory Keywords'
    ip '1.2.3.4'
  end

  factory :signup_token do
    email 'test@example.com'
  end

  factory :user do
    email 'test@example.com'
    password 'secret'
    association :signup_token
  end
end
