# Vagrant Multi-Machine<br>создаём несколько преднастроенных машин используя один Vagrantfile #

## Системные требования к приложению ##

- устройство, с предустановленной операционной системой:
  - Windows Server;
  - или Windows 10 Корпоративная, Pro или для образовательных учреждений;
  - роль Hyper-V невозможно установить в Windows 10 Домашняя;
- 64-разрядный процессор с поддержкой преобразования адресов второго уровня (SLAT).
- ЦП должен поддерживать расширения режима мониторинга виртуальной машины (VT-c на процессорах Intel).
- Не менее 8 ГБ оперативной памяти.
- программное обеспечение:
  - система контроля версий Git;
  - система виртуализации:
    - Virtualbox;
    - или Hyper-V.
  - Vagrant.

## Если не установлен Git ##

- [Установка в Windows]()
- [Первоначальная настройка Git]()
- ...
- [Эти и другие знания про Git](https://github.com/My-PP/Today-I-Learned/blob/main/Git/README.md)

## Если не установлен Virtualbox ##

- [Установка в Windows]()
- ...
- [Эти и другие знания про Virtualbox](https://github.com/My-PP/Today-I-Learned/blob/main/Virtualbox/README.md)

## Если не установлен Microsoft Hyper-V ##

- [Проверьте следующие требования](https://github.com/My-PP/Today-I-Learned/blob/main/Hyper-V/README.md#1)
- [Включение аппаратной виртуализации](https://github.com/My-PP/Today-I-Learned/blob/main/Hyper-V/README.md#2)
- ...
- [Эти и другие знания про Microsoft Hyper-V](https://github.com/My-PP/Today-I-Learned/blob/main/Hyper-V/README.md#hyper-vd)

## Если не установлен Vagrant ##

- [Начало работы с Vagrant](https://github.com/My-PP/Today-I-Learned/blob/main/Vagrant/README.md#1)
- ...
- [Эти и другие знания про Vagrant](https://github.com/My-PP/Today-I-Learned/blob/main/Vagrant/README.md)

## Установка приложения Vagrant Multi-Machine с GitHub ##

Исходный код Vagrant Multi-Machine доступен через [репозиторий на GitHub](https://github.com/My-PP/vagrant-multi-machine). Загрузите код из репозитория в каталог на вашем веб-сервере, для этого:

- запускаем утилиту `Git Bash`

- переходим в локальную папку, где планируется развернуть приложение Vagrant Multi-Machine:<br>
`cd %PATH%` например в папку C:\projects

```bash
cd /c/projects/
```

- выполняем команду:

```bash
git clone git@github.com:My-PP/vagrant-multi-machine.git
```

- переходим во вновь созданную папку:

```bash
cd vagrant-multi-machine
```

- подключаем требуемые виртуальные машины в конфигурационном файле config/vagrant/vagrant-config-vms.yaml

- настраиваем глобальные переменные в конфигурационном файле config/vagrant/vagrant-config-global.yaml

- выполняем команду `vagrant up` - эта команда смотрит в Vagrantfile и создаёт виртуальную машину согласно описания.

## Конфигурационный файл config/vagrant/vagrant-config-vms.yaml ##

Доступные виртуальные машины:

- ~~система контроля версий GitLab Community Edition~~;
- ~~сервер непрерывной интеграции (билд-сервер)~~;
- сервер разработки приложений;
- MySQL сервер баз данных с установленным phpMyAdmin;
- ~~PostgreSQL сервер баз данных~~;
- ~~почтовый сервер~~;
- [дорожная карта приложений, ToDo](TODO.md).

Для каждой виртуальной машины предопределён список обязательных и дополнительных переменных.

Чтобы виртуальная машина создалсь, необходимо параметр `setup` предопределить как `true`. Доступные переменные для этого параметра: `true`, `false`

## Конфигурационный файл config/vagrant/vagrant-config-global.yaml ##

## Для того, чтобы увидеть приложения в браузере ##

открыть файл 'C:\Windows\System32\drivers\etc\hosts' в режиме администратора, чтобы иметь возможность редактировать его, и добавить туда следующие строчки:

- 127.0.0.1 wordpress.local
- 127.0.0.1 drupal.local

## Доступные в браузере URL приложения Vagrant Multi-Machine ##

- [localhost:8094/phpmyadmin](http://localhost:8094/phpmyadmin)
- [wordpress.local:8093](http://wordpress.local:8093)
- [drupal.local:8093](http://drupal.local:8093)
