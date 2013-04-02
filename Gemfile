source "http://rubygems.org"

gem "rails", "~> 3.2.0"

gem 'jquery-rails'
gem 'jquery-ui-themes'

gem "active_scaffold", github: "activescaffold/active_scaffold"
gem "recordselect"
gem "russian"
gem "devise", "~> 2.2.0"
gem "devise-encryptable"
gem 'cancan'
gem "erubis"
gem "haml"
gem "pdfkit"
gem "pg"
gem 'activerecord-postgres-hstore', github: 'engageis/activerecord-postgres-hstore'
gem 'whenever'
gem 'unicode'
gem 'nokogiri'
gem 'validates_timeliness'
gem 'axlsx_rails'
gem 'redcarpet'
gem 'google-analytics-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', " ~> 3.2.0"
  gem 'coffee-rails', " ~> 3.2.0"
  gem 'select2-rails'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'libv8', '~> 3.11.8' # For therubyracer gem
end

group :production do
  gem 'unicorn'

  # Backup automated system
  gem 'backup', '~> 3.0'
  gem 'net-ssh', '~> 2.3.0'
  gem 'net-scp'
  gem 'dropbox-sdk', '~> 1.2.0'
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
