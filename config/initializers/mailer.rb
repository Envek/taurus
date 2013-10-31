# It's required for links generation in emails
Taurus::Application.config.action_mailer.default_url_options = { host: 'taurus.amursu.ru' }

Taurus::Application.config.action_mailer.default_url_options = { :host => 'localhost:3000' } if Rails.env.development?

Taurus::Application.config.action_mailer.delivery_method = :smtp

Taurus::Application.config.action_mailer.smtp_settings = Settings.mailer