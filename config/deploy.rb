# call with `cap -S app="<app>" deploy` to deploy to another instance.

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Для работы rvm
require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика. 

ssh_options[:forward_agent] = true # Используем локальные ключи, а не ключи сервера
default_run_options[:pty] = true   # Для того, чтобы можно было вводить пароль

set :application, "taurus"
set :rails_env, "production"
set :domain, "taurus@taurus.amursu.ru" # Это необходимо для деплоя через ssh.

# Prevents error if not parameter passed, assumes that default 'cap deploy'
# command should deploy default application instance
set(:app, application) unless exists?(:app)
unless app.nil?
   set :deploy_to, "/srv/#{app}"
else
   set :deploy_to, "/srv/#{application}"
end

set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_string, 'ree@taurus' # Это указание на то, какой Ruby интерпретатор мы будем использовать.
set :rvm_type, :user # Указывает на то, что мы будем использовать rvm, установленный у пользователя, от которого происходит деплой, а не системный rvm.

set :scm, :git
set :repository,  "git@github.com:AmurSU/taurus.git" # Путь до вашего репозитария. Кстати, забор кода с него происходит уже не от вас, а от сервера, поэтому стоит создать пару rsa ключей на сервере и добавить их в deployment keys в настройках репозитария.
set :branch, "master" # Ветка из которой будем тянуть код для деплоя.
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

after 'deploy:update_code', :roles => :app do
  # Конфиги. Их не трогаем!
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
  
  run "rm -f #{current_release}/config/taurus.yml"
  run "ln -s #{deploy_to}/shared/config/taurus.yml #{current_release}/config/taurus.yml"
end

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
