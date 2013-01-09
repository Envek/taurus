# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods
end
