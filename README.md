# Vagrant Multi-Machine<br>создаём несколько преднастроенных машин используя один Vagrantfile #

## Системные требования к приложению ##

- устройство
  - с предустановленной операционной системой Windows Server, Windows 10 Корпоративная, Pro или для образовательных учреждений, так как роль Hyper-V **невозможно** установить в Windows 10 Домашняя;
  - 64-разрядный процессор с поддержкой преобразования адресов второго уровня (SLAT).
  - ЦП должен поддерживать расширения режима мониторинга виртуальной машины (VT-c на процессорах Intel).
  - Не менее 8 ГБ оперативной памяти.
- программное обеспечение:
  - система контроля версий Git;
  - система виртуализации:
    - Virtualbox;
    - ~~или Hyper-V~~.
  - Vagrant.

## Если не установлен Git ##

- [Установка в Windows](https://github.com/My-PP/Today-I-Learned/blob/main/Git/README.md)
- [Первоначальная настройка Git](https://github.com/My-PP/Today-I-Learned/blob/main/Git/README.md)
- ...
- [Эти и другие знания про Git](https://github.com/My-PP/Today-I-Learned/blob/main/Git/README.md)

## Если не установлен Virtualbox ##

- [Установка в Windows](https://github.com/My-PP/Today-I-Learned/blob/main/Virtualbox/README.md)
- ...
- [Эти и другие знания про Virtualbox](https://github.com/My-PP/Today-I-Learned/blob/main/Virtualbox/README.md)

## Если не установлен Microsoft Hyper-V ##

- ну и правильно, на данном этапе;
- он всё равно не работает одновременно с Virtualbox;
- ...
- [Но здесь можно подчерпнуть знания про Microsoft Hyper-V](https://github.com/My-PP/Today-I-Learned/blob/main/Hyper-V/README.md#hyper-vd)

## Если не установлен Vagrant ##

- [Начало работы с Vagrant](https://github.com/My-PP/Today-I-Learned/blob/main/Vagrant/README.md#1)
- ...
- [Эти и другие знания про Vagrant](https://github.com/My-PP/Today-I-Learned/blob/main/Vagrant/README.md)

## Установка приложения Vagrant Multi-Machine с GitHub ##

Исходный код Vagrant Multi-Machine доступен через [репозиторий на GitHub](https://github.com/My-PP/vagrant-multi-machine). Загрузите код из репозитория в каталог на вашем веб-сервере, для этого:

- запускаем утилиту `Git Bash`

- переходим в локальную папку, где планируется развернуть приложение Vagrant Multi-Machine, в `Git Bash` выполняем команду `cd %PATH%` например, если папка C:\projects, то:

```bash
cd /c/projects/
```

- выполняем команду в `Git Bash`:

```bash
git clone git@github.com:My-PP/vagrant-multi-machine.git
```

- переходим во вновь созданную папку, выполняем команду в `Git Bash`:

```bash
cd vagrant-multi-machine
```

- подключаем необходимые виртуальные машины в конфигурационном файле `config/vagrant/vagrant-config-vms.yaml`

- настраиваем глобальные переменные в конфигурационном файле `config/vagrant/vagrant-config-global.yaml`

- в `Git Bash` выполняем команду `vagrant up` - эта команда смотрит в Vagrantfile, читает конфигурационные файлы<br>`/config/vagrant/vagrant-config-vms.yaml`<br>и<br>`/config/vagrant/vagrant-config-global.yaml`<br>проходит по элементам массива и создаёт виртуальные машины в цикле согласно описания.

## Конфигурационный файл config/vagrant/vagrant-config-vms.yaml ##

### Доступные виртуальные машины ###

- ~~система контроля версий GitLab Community Edition~~;
- ~~сервер непрерывной интеграции (билд-сервер)~~;
- сервер разработки приложений;
- MySQL сервер баз данных с установленным phpMyAdmin;
- ~~PostgreSQL сервер баз данных~~;
- ~~почтовый сервер~~;
- [дорожная карта разработки, ToDo](TODO.md).

Для каждой виртуальной машины предопределён список обязательных и дополнительных переменных. Описание в соответствующем YAML-файле с настройками.

Чтобы виртуальная машина создалсь и запустилась, необходимо параметр `setup` предопределить как `true`. Доступные переменные для этого параметра: `true`, `false`.

Чтобы добавить ещё одну виртуальную машину, просто добавьте её в массив VMs конфигурационного файла `/config/vagrant/vagrant-config-vms.yaml`

### Доступные виртуальные хосты ###

- localhost:8093
- drupal.local:8093
- wordpress.local:8093
- localhost:8094

Для каждой из виртуальных машин существует дополнительный, необязательный параметр: `VirtualHost` 

Vagrant, при наличии параметра в конфигурационном файле `/config/vagrant/vagrant-config-vms.yaml`, в цикле прочитает данные, автоматически добавит виртуальный хост, зарегистрирует и добавит запись в `/etc/hosts`

## Конфигурационный файл config/vagrant/vagrant-config-global.yaml ##

## Доступные в браузере URL приложения Vagrant Multi-Machine ##

Для того, чтобы открыть приложения в браузере, необходимо открыть файл `C:\Windows\System32\drivers\etc\hosts` в режиме администратора, чтобы иметь возможность редактировать его, и добавить туда следующие строчки:

- 127.0.0.1 wordpress.local
- 127.0.0.1 drupal.local

После этого в браузере будут доступны приложения по ссылкам:

- сервер разработки приложений
  - [wordpress.local:8093](http://wordpress.local:8093)
  - [drupal.local:8093](http://drupal.local:8093)
- MySQL сервер баз данных
  - [localhost:8094/phpmyadmin](http://localhost:8094/phpmyadmin)