source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'dbf'
  gem 'json'
  gem 'nokogiri'

  gem 'rspec'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'

  if ENV['CI']
    gem 'coveralls', require: false
  end
end
