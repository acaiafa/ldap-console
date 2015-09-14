source 'https://rubygems.org'

gem 'sinatra'
gem 'net-ldap'
gem 'sinatra-bootstrap', :require => 'sinatra/bootstrap'
gem 'encrypted_cookie'
gem 'sinatra-flash'

group :development, :test do
 gem 'rspec'
 gem 'pry'
 gem 'rack-test'
 gem 'capistrano', '~> 2.15.5'
 gem 'capistrano-ext', '1.2.1'
end

group :production do
 gem 'unicorn'
end
