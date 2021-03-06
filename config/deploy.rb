# -*- encoding : utf-8 -*-
# call with `cap -S app="<app>" -S domain="<domain>" deploy` to deploy to another instance and/or server.

ssh_options[:forward_agent] = true # Используем локальные ключи, а не ключи сервера
default_run_options[:pty] = true   # Для того, чтобы можно было вводить пароль

set :application, exists?(:app) && app.any? ? app : "taurus"
set :rails_env, "production"
set :domain, exists?(:domain) && domain.any? ? domain : "taurus@taurus.amursu.ru" # Это необходимо для деплоя через ssh.

set :deploy_to, "/srv/#{application}"

set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_string, '1.9.3' # Это указание на то, какой Ruby интерпретатор мы будем использовать.
set :rvm_type, :user # Указывает на то, что мы будем использовать rvm, установленный у пользователя, от которого происходит деплой, а не системный rvm.

set :scm, :git
set :repository,  "git@github.com:AmurSU/taurus.git" # Путь до вашего репозитария. Кстати, забор кода с него происходит уже не от вас, а от сервера, поэтому стоит создать пару rsa ключей на сервере и добавить их в deployment keys в настройках репозитария.
set :branch, "master" # Ветка из которой будем тянуть код для деплоя.
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.

set :whenever_command, "bundle exec whenever"
set :whenever_identifier, application
require "whenever/capistrano"

# Автосоздание конфигов при необходимости
after 'deploy:update_code', :roles => :app do
  run "test -d #{deploy_to}/shared/config || mkdir #{deploy_to}/shared/config"
  run "test -f #{deploy_to}/shared/config/database.yml || cp #{current_release}/config/database.yml.example #{deploy_to}/shared/config/database.yml"
  run "test -f #{deploy_to}/shared/config/settings.yml || cp #{current_release}/config/settings.yml.example #{deploy_to}/shared/config/settings.yml"
  run "test -f #{deploy_to}/shared/config/newrelic.yml || cp #{current_release}/config/newrelic.yml.example #{deploy_to}/shared/config/newrelic.yml"
end

after 'deploy:update_code', :roles => :app do
  # Конфиги. Их не трогаем!
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"

  run "rm -f #{current_release}/config/settings.yml"
  run "ln -s #{deploy_to}/shared/config/settings.yml #{current_release}/config/settings.yml"

  run "rm -f #{current_release}/config/newrelic.yml"
  run "ln -s #{deploy_to}/shared/config/newrelic.yml #{current_release}/config/newrelic.yml"
end

# Для автоматической прекомпиляции assets
load 'deploy/assets'

# Далее идут правила для перезапуска unicorn.
# В случае с Rails 3 приложениями стоит заменять bundle exec unicorn_rails на bundle exec unicorn
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
