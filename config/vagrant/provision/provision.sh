#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

echo -e "\e[34m Применяем общую конфигурацию для всех виртуальных машин \e[0m"
# Синхронизируем списки пакетов и репозиториев и обеспечиваем их актуальность
apt-get update > /dev/null
# Обновляем пакеты до последних версий и устанавливаем новые пакеты, если они требуются в качестве зависимостей
apt-get -y upgrade > /dev/null

echo -e "\e[34m Устанавливаем базовые пакеты: \e[0m"

echo -e "\e[34m - Midnight Commander (mc) \e[0m"
apt-get -y install mc > /dev/null

echo -e "\e[34m - Wget \e[0m"
apt-get -y install wget > /dev/null

echo -e "\e[34m - debconf-utils \e[0m"
apt-get -y install debconf-utils > /dev/null

echo -e "\e[34m - cURL \e[0m"
apt-get -y install curl > /dev/null

echo -e "\e[34m - build-essential \e[0m"
apt-get -y install build-essential > /dev/null

echo -e "\e[34m - полезные скрипты для добавления и удаления PPA \e[0m"
apt-get -y install software-properties-common > /dev/null



