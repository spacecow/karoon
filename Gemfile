if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'mysql2'
gem 'execjs'
gem 'ancestry'
gem 'therubyracer'
gem 'jquery-rails'
gem 'formtastic'
gem 'cancan'
gem 'carrierwave'
gem 'rmagick', '2.12.2'
gem 'annotate', '~> 2.4.1.beta' 
gem 'aasm'
gem 'redis'
gem 'yajl-ruby'
gem 'rabl'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'will_paginate', '> 3.0' 

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'compass-rails'
  gem 'fancy-buttons'
end

group :development do
  gem 'rspec-rails'
end

group :test do
  gem 'email_spec'
  gem 'spork-rails' #, '> 0.9.0.rc'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'factory_girl_rails', '1.2.0'
  gem 'capybara'
  gem 'launchy'
  gem 'libnotify'
end
