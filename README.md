Cистема составления учебного расписания «Taurus»
================================================

Веб-ориентированное приложение для составления и публикации учебного расписания.

Установка
---------

Рекомендуемый тип установки: установка на сервер или рабочую станцию с GNU/Linux, с использованием [RVM][] из под непривилегированного пользователя.

### Установка интерпретатора Ruby

	bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer ) # Установка RVM
	source ~/.bashrc # перезагрузка оболочки для функционирования RVM
	rvm requirements # Эта команда выведет пакеты, которые вам нужно будет установить
	# Установите то, о чём вас попросили в предыдущей команде!
	rvm install ree  # Установка интерпретатора языка ruby, версии 1.8.7 enterprise edition
	rvm --default use ree # Использовать этот интерпретатор по умолчанию для текущего пользователя
	gem install bundler # Установка менеджера зависимостей

### Установка приложения

	cd /path/to/working/directory
	git clone git@github.com:AmurSU/taurus.git # Получение актуального исходного кода
	cd taurus
	bundle install # Установка всех зависимостей приложения

### Настройка

	cp config/database.yml.sample config/database.yml
	cp config/taurus.yml.sample config/taurus.yml

Отредактируйте файл `config/database.yml` для вашей базы данных.

Отредактируйте файл `config/taurus.yml` под ваши нужды.

### Завершение установки

	rake db:setup # Создание базы данных и её заполнение стандартными значениями

Теперь можно запустить приложение локально при помощи команды `script/server`.

### Для работы экспорта в PDF

Установите wkhtmltopdf, например так:

  wget http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-amd64.tar.bz2 
  tar xvjf wkhtmltopdf-0.9.9-static-amd64.tar.bz2
  sudo mv wkhtmltopdf-amd64 /usr/local/bin/wkhtmltopdf
  sudo chmod +x /usr/local/bin/wkhtmltopdf

Отладка
-------

### Журналирование

Проверяйте лог-файлы приложения (находятся в директории `log`) при помощи команды `tail -f`:

 1. server.log
 2. development.log

Возможна запись своих сообщений в лог-файл. Пример:

	class WeblogController < ActionController::Base
		def destroy
			@weblog = Weblog.find(params[:id])
			@weblog.destroy
			logger.info("#{Time.now} Destroyed Weblog ID ##{@weblog.id}!")
		end
	end

В результате в лог-файле появится запись следующего вида:

	Mon Oct 08 14:22:29 +1000 2007 Destroyed Weblog ID #1

### Отладчик

Для работы отладчика вам понадобится пакет `ruby-debug`.

Вызов отладчика возможен через команду debugger в исходном коде. Например:

	class WeblogController < ActionController::Base
		def index
			@posts = Post.find(:all)
			debugger
		end
	end

Контроллер начнёт выполнять действие, исполнит первую строчку кода и в консоли сервера предоставит интерактивную ruby-оболочку.

Когда закончите с отладчиком, введите `cont`.


### Консоль

Вызов команды `script/console` приведёт к запуску консоли приложения.

Вы получите полностью сконфигурированное и запущенное приложение и будете иметь доступ ко всем моделям, сможете изменять значения и сохранять их в базу данных.
Для перезагрузки контроллеров и моделей выполните `reload!`

### Консоль БД

Вызов команды `script/dbconsole` приведёт к тому, что вы будете подключены к консоли вашей базы данных с учётными данными указанными в database.yml.

Помощь в разработке
-------------------

Если вы хотите помочь проекту:

 1. Сделайте форк проекта в своём github-аккаунте.
 2. Создайте отдельную ветвь разработки.
 3. Внесите в неё желаемые изменения.
 4. Создайте pull-request из вашей ветви в ветвь master данного репозитария.

Подробнее об этой модели разработки вы можете прочесть в [данной статье][pull].

[RVM]: http://beginrescueend.com/ "Официальный сайт Ruby Version Manager"
[pull]: http://habrahabr.ru/blogs/Git/125999/ "Статья «Pull request'ы на GitHub или Как мне внести изменения в чужой проект» на Habrahabr.ru"
