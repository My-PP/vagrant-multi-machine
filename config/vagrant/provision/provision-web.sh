#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

echo -e "\e[34m Конфигурируем сервер разработки приложений \e[0m"
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

apt-get -y install curl > /dev/null
apt-get -y install build-essential > /dev/null
apt-get -y install software-properties-common > /dev/null

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHPVERSION/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHPVERSION/apache2/php.ini

sudo service apache2 restart

echo -e "\e[34m Удаляем все существующие виртуальные хосты \e[0m"
sudo rm -rf /etc/apache2/sites-available/*.conf
sudo rm -rf /etc/apache2/sites-enabled/*.conf

