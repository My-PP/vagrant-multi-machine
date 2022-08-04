#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

echo -e "\e[34m Конфигурируем MySQL сервер баз данных \e[0m"
echo -e "\e[34m Устанавливаем базовые пакеты \e[0m"

echo -e "\e[34m Устанавливаем Apache сервер \e[0m"
apt-get -y install apache2 > /dev/null

echo -e "\e[34m Устанавливаем PHP версии $PHPVERSION \e[0m"
apt-get -y install php$PHPVERSION libapache2-mod-php$PHPVERSION > /dev/null

echo -e "\e[34m Устанавливаем необходимые PHP расширения \e[0m"
apt-get -y install php$PHPVERSION-mysql > /dev/null
apt-get -y install php$PHPVERSION-memcached > /dev/null
apt-get -y install php$PHPVERSION-pgsql > /dev/null
apt-get -y install php$PHPVERSION-gd > /dev/null
apt-get -y install php$PHPVERSION-imagick > /dev/null
apt-get -y install php$PHPVERSION-intl > /dev/null
apt-get -y install php$PHPVERSION-xml > /dev/null
apt-get -y install php$PHPVERSION-zip > /dev/null
apt-get -y install php$PHPVERSION-mbstring > /dev/null
apt-get -y install php$PHPVERSION-curl > /dev/null



echo -e "\e[34m Устанавливаем MySQL root user password \e[0m"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

echo -e "\e[34m Устанавливаем MySQL server \e[0m"
apt-get -y install mysql-server mysql-client > /dev/null

# Устраняем необходимость вводить логин и пароль.
# Сохраним пароль в ~/.my.cnf После этого mysql и mysqladmin просить пароль перестанут.
echo -e "\e[34m Создаём файл конфигурации учетной записи \e[0m"
cat > /root/.my.cnf <<EOF
[client]
user="$DBPASSWD"
password="$DBPASSWD"
EOF

sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
sudo service mysqld restart

echo -e "\e[34m Создаём базу данных сервера разработки приложений $DBNAME \e[0m"
sudo mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DBNAME"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON $DBNAME.* to '$DBUSER'@'%'"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"

echo -e "\e[34m Устанавливаем MySQL интерфейс phpMyAdmin \e[0m"
apt-get -y install phpmyadmin > /dev/null

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo a2enmod rewrite

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHPVERSION/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHPVERSION/apache2/php.ini

sudo service apache2 restart
sudo service mysql restart

