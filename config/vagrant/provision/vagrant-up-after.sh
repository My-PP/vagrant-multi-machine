#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

# ОЧИСТКА СИСТЕМЫ
#   Ни для кого не секрет что система в процессе своей работы засоряется. Установка и удаление программ, выполнение
#   скриптов, обновления, неверная установка программ из исходников, ошибки в программах, все это оставляет в системе лишние, 
#   ненужные пакеты. Со временем этих файлов может накапливаться достаточно большое количество. 

echo -e "\e[34m - удаляем неиспользуемые пакеты из кэша \e[0m"
sudo apt autoclean
  
echo -e "\e[34m - очищаем кэш утилиты apt \e[0m"
sudo apt clean

echo -e "\e[34m - удаляем ненужные зависимости \e[0m"
sudo apt autoremove
