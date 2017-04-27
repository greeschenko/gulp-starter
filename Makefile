#Makefile

NAME=/var/www/html/

devconfigure:

	cat config/db.php | sed "s/yii2basic/${NAME}/g" > config/db.php_tmp
	cat config/db.php_tmp | sed "/password/s/''/'rootpass'/g" > config/db.php_new
	rm config/db.php_tmp
	rm config/db.php
	mv config/db.php_new config/db.php

	cat config/test_db.php | sed "s/yii2_basic_tests/${NAME}/g" > config/test_db.php_new
	rm config/test_db.php
	mv config/test_db.php_new config/test_db.php

	cat config/web.php | sed "s/basic/${NAME}/g" > config/web.php_new
	rm config/web.php
	mv config/web.php_new config/web.php

	cat Vagrantfile | sed "s/vagrantmashine/vagrantmashine.${NAME}/g" > Vagrantfile_new
	rm Vagrantfile
	mv Vagrantfile_new Vagrantfile

	IPNUM=`wc -l /etc/hosts | awk '{print($$1)}'`

	cat Vagrantfile | sed "s/192.168.88.88/192.168.88.$$(( ${IPNUM} + 1 ))/g" > Vagrantfile_new
	rm Vagrantfile
	mv Vagrantfile_new Vagrantfile

	cat provision.sh | sed "s/myproject/${NAME}/g" > provision.sh_new
	rm provision.sh
	mv provision.sh_new provision.sh

	sudo -- sh -c "echo 192.168.88.$$(( ${IPNUM} + 1 )) ${NAME}.ga >> /etc/hosts"

	echo '.vagrant/' >> .gitignore

	vagrant up

	chromium ${NAME}.ga

serverconfigure:

	CPSPATH='/usr/local/bin/composer'
	curl -sS https://getcomposer.org/installer | php;
	mv composer.phar /usr/local/bin/composer;
	echo 'composer installed!!!';

	composer global require "fxp/composer-asset-plugin:^1.2.0"

	CODEPATH1=${HOME}'/.config/composer/vendor/bin';
	CODEPATH2=${HOME}'/.composer/vendor/codeception/codeception';

	@if [[ -f $$CODEPATH1'/codecept' ]]; then \
		echo 'PATH=$$PATH:'$$CODEPATH1 >> $$HOME'/.bashrc'; \
		echo 'export PATH' >> $$HOME'/.bashrc'; \
		source $$HOME'/.bashrc'; \
		echo 'in 1'; \
	fi

	@if [[ -f $$CODEPATH2'/codecept' ]]; then \
		echo 'PATH=$$PATH:'$$CODEPATH2 >> $$HOME'/.bashrc'; \
		echo 'export PATH' >> $$HOME'/.bashrc'; \
		source $$HOME'/.bashrc'; \
		echo 'in 2'; \
	else \
		composer global require "codeception/codeception=2.1.*"; \
	fi

	@if [[ -f $$CODEPATH1'/codecept' ]]; then \
		echo 'PATH=$$PATH:'$$CODEPATH1 >> $$HOME'/.bashrc'; \
		echo 'export PATH' >> $$HOME'/.bashrc'; \
		source $$HOME'/.bashrc'; \
		echo 'in 1'; \
	elif [[ -f $$CODEPATH2'/codecept' ]]; then \
		echo 'PATH=$$PATH:'$$CODEPATH2 >> $$HOME'/.bashrc'; \
		echo 'export PATH' >> $$HOME'/.bashrc'; \
		source $$HOME'/.bashrc'; \
		echo 'in 2'; \
	fi

	composer global require "codeception/specify=*"
	composer global require "codeception/verify=*"
	composer install

serverinit:

	#composer update
	@if ! [ -d web/assets ]; then \
		mkdir web/assets; \
	fi
	@if ! [ -d web/uploads ]; then \
		mkdir web/uploads; \
	fi
	chmod -R 777 runtime
	chmod -R 777 web/assets
	chmod -R 777 web/uploads
	php yii migrate --migrationPath=@vendor/greeschenko/yii2-file/migrations --interactive=0
	php yii migrate --migrationPath=@vendor/greeschenko/yii2-prozorrosale/migrations --interactive=0
	php yii migrate --migrationPath=@vendor/greeschenko/yii2-sysmsgs/migrations --interactive=0

work:

	vagrant up
	tmux split-window -l 10 'vagrant ssh -- -t "cd ${NAME}; /bin/bash"'
	tmux split-window -h 'vagrant ssh -- -t "cd ${NAME}; /bin/bash"'
	tmux split-window 'vagrant ssh -- -t "cd ${NAME}; /bin/bash"'
	tmux select-pane -t 0
	vim

up:

	php yii migrate/up --migrationPath=@vendor/greeschenko/yii2-file/migrations --interactive=0
	php yii migrate/up --migrationPath=@vendor/greeschenko/yii2-prozorrosale/migrations --interactive=0
	php yii migrate/up --migrationPath=@vendor/greeschenko/yii2-sysmsgs/migrations --interactive=0
	php yii migrate/up --migrationPath=@vendor/greeschenko/yii2-contentelements/migrations --interactive=0

