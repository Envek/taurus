# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# We're using UTF-8 everywhere!
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the rails application
Taurus::Application.initialize!
