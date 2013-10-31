Backup::Model.new(:taurus, 'Taurus backup configuration') do

  db_config  = YAML.load_file("#{File.dirname(__FILE__)}/database.yml")
  app_config = YAML.load_file("#{File.dirname(__FILE__)}/settings.yml")

  database PostgreSQL do |db|
    db.name = db_config['production']['database']
    db.username = db_config['production']['username']
    db.password = db_config['production']['password']
    db.host = db_config['production']['host']
    db.port = db_config['production']['port']
    db.skip_tables = ['sessions', 'sessions_id_seq']
    db.additional_options = ['--clean']
  end

  compress_with Bzip2

  store_with SCP do |server|
    server.username = app_config['backup']['server']['username']
    server.password = app_config['backup']['server']['password']
    server.ip       = app_config['backup']['server']['ip']
    server.port     = app_config['backup']['server']['port']
    server.path     = app_config['backup']['server']['path']
    server.keep     = app_config['backup']['server']['keep']
  end

  store_with Dropbox do |db|
    db.api_key    = app_config['backup']['dropbox']['api_key']
    db.api_secret = app_config['backup']['dropbox']['api_secret']
    db.path       = app_config['backup']['dropbox']['path']
    db.keep       = 5
  end

  store_with Local do |local|
    local.path = app_config['backup']['local']['path']
    local.keep = app_config['backup']['local']['keep']
  end

  notify_by Mail do |mail|
    mail.on_success = true
    mail.on_failure = true

    mail.from = "#{app_config['mailer']['user_name'] || 'andrey.novikov'}@#{app_config['mailer']['domain']|| 'amursu.ru'}"
    mail.to = app_config['backup']['email']['to']
    mail.address = app_config['mailer']['address']
    mail.domain = app_config['mailer']['domain'] || 'amursu.ru'
    mail.port = app_config['mailer']['port']
    mail.authentication = app_config['mailer']['authentication'] if app_config['mailer']['authentication']
  end

end
