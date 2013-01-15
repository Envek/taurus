source "http://rubygems.org"

gem "rails", "~> 4.0.0"
gem 'activerecord-deprecated_finders'
gem 'protected_attributes'

gem 'jquery-rails', '~> 2.1.0'
gem 'jquery-ui-themes'

gem "active_scaffold", path: '~/active_scaffold'
gem "recordselect"
gem "russian"
gem "devise", "~> 3.0.0"
gem "devise-encryptable"
gem 'cancan'
gem "erubis"
gem "haml"
gem "pdfkit"
gem "pg"
gem 'whenever'
gem 'unicode'
gem 'nokogiri'
gem 'validates_timeliness'
gem 'axlsx_rails'
gem 'redcarpet'
gem 'google-analytics-rails'
gem 'rqrcode-rails3'
gem 'mini_magick'

# Gems used only for assets and not required
# in production environments by default.
gem 'haml-rails'
gem 'sass-rails', " ~> 4.0.0"
gem 'coffee-rails', " ~> 4.0.0"
gem 'select2-rails', '~> 3.3.0'
gem 'uglifier'
gem 'therubyracer', platforms: :ruby
gem 'libv8', '~> 3.11.8' # For therubyracer gem


group :production do
  gem 'unicorn'

  # Backup automated system
  gem 'backup', '~> 3.0'
  gem 'net-ssh', '~> 2.3.0'
  gem 'net-scp'
  gem 'dropbox-sdk'
  gem 'mail'
end

group :development do
  gem "capistrano"
  gem "rvm-capistrano"
  gem 'debugger'
  gem 'travis-lint'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

gem 'rspec-rails', :group => [:development, :test]
gem 'rspec',       :group => [:development, :test]

group :test do
  gem 'rake'
  gem 'factory_girl_rails'
  gem 'factory_girl', '~> 2.1.0'
  gem 'capybara'
  gem 'launchy'
  gem 'poltergeist'
end
