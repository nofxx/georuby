source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'dbf'
  gem 'json'
  gem 'rspec'
  gem 'guard'
  gem 'guard-rspec'
  gem 'nokogiri'

  if ENV['CI']
    gem 'coveralls', require: false
  end
end
