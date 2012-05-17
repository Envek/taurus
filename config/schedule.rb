env :PATH, ENV['PATH']

app = "taurus"
rails_env = "production"
ruby = "ree@taurus"
deploy_to  = "/srv/taurus"
current = "#{deploy_to}/current"
unicorn_conf = "#{current}/config/unicorn.rb"
unicorn_pid = "#{deploy_to}/shared/pids/unicorn.pid"

if environment == 'production'

  # Запуск сервера после перезагрузки
  every :reboot do
    command "rvm use #{ruby} && cd #{current} && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end

  # Если Unicorn упал, пытаемся поднять
  every 1.minute do
    command "if [ ! -f #{unicorn_pid} ] || [ ! -e /proc/$(cat #{unicorn_pid}) ]; then rvm use #{ruby} && cd #{current} && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end

  every :day, :at => '8pm' do
    command "rvm use #{ruby} && cd #{current} && bundle exec backup perform --trigger #{app} --config-file #{current}/config/backup.rb"
  end

end
