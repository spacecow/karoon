if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'mysql2'
gem 'execjs'
gem 'ancestry'
gem 'therubyracer'
gem 'jquery-rails'
gem 'formtastic'
gem 'cancan'
gem 'compass', '>= 0.12.alpha.0'
gem 'carrierwave'
gem 'rmagick', '2.12.2'
gem 'annotate'
gem 'aasm'
gem 'fancy-buttons'
gem 'redis'
gem 'yajl-ruby'

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :development do
  gem 'rspec-rails', '2.7.0'
end

group :test do
  gem 'spork', '> 0.9.0.rc'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'factory_girl'
  gem 'capybara'
  gem 'launchy'
  gem 'libnotify'
end
