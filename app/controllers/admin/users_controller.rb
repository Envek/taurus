class Admin::UsersController < Admin::BaseController
  active_scaffold :user do |config|
    config.columns = [:name, :login, :email, :password, :password_confirmation]
    config.list.columns = [:name, :login, :email, :current_sign_in_at, :current_sign_in_ip]
    config.columns[:email].form_ui = :email
    config.columns[:password].form_ui = :password
    config.columns[:password_confirmation].form_ui = :password
  end
end
