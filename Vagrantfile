# -*- mode: ruby -*-
# vi: set ft=ruby :

# ЗАВОРАЧИВАЕМ ПУТЬ В ПЕРЕМЕННУЮ:
current_dir = File.join(File.dirname(__FILE__))

# ПОДКЛЮЧАЕМ И ЧИТАЕМ YAML-ФАЙЛ С НАСТРОЙКАМИ:
require 'yaml'
if File.file?("#{current_dir}/config/vagrant/vagrant-config-vms.yaml") && File.file?("#{current_dir}/config/vagrant/vagrant-config-global.yaml")
  configvms     = YAML.load_file("#{current_dir}/config/vagrant/vagrant-config-vms.yaml")
  configglobal  = YAML.load_file("#{current_dir}/config/vagrant/vagrant-config-global.yaml")
else
  raise "Конфигурационный файл отсутствует"
end

Vagrant.configure("#{configglobal["GLOBAL"]["api_version"]}") do |config|
  # ПРОХОДИМ ПО ЭЛЕМЕНТАМ МАССИВА ИЗ YAML-ФАЙЛА С НАСТРОЙКАМИ:
  #   глобальная инициализация будет выполняться сначала для каждой из виртуальных машин, а затем будет инициализация 
  #   с ограниченной областью действия. Поместив контроллер в конец списка, он будет последним, для которого выполняется 
  #   инициализация. Вы можете упорядочить загрузку, изменив порядок из списка и создав дополнительные условия. 
  configvms["VMs"].each do |configvms|
    if configvms["setup"] == true
      config.vm.define configvms["name"] do |vm|
        if configglobal["GLOBAL"]["box_usage"] == true
          vm.vm.box = configglobal["GLOBAL"]["box"]
          vm.vm.box_version = configglobal["GLOBAL"]["box_version"]
        else
          vm.vm.box = configvms["box"]
          vm.vm.box_version = configvms["box_version"]
        end

        # ТРИГГЕРЫ:
        vm.trigger.after :up do |trigger|
          trigger.name = "\e[34m clean VM #{configvms["name"]} after vagrant up\e[0m"
          trigger.info = "\e[34m  \e[0m"
          trigger.run_remote  = {path: "#{current_dir}/config/vagrant/provision/vagrant-up-after.sh"}
        end
        
        # РАСШИРЕННАЯ КОНФИГУРАЦИЯ:
        #   Провайдер(англ. Provider) представляет собой программное обеспечение для создания и управления виртуальными машинами, используемыми в Vagrant. 
        #   Основыными провайдерами являются Virtualbox и VMware.
        if configglobal["GLOBAL"]["vagrant_provider"] == "virtualbox"
          memory = configvms["memory"]  ? configvms["memory"]  : 1024;
          cpu = configvms["cpu"]  ? configvms["cpu"]  : 1;
          name = configvms["name"];
          vm.vm.provider :virtualbox do |vb|
            vb.customize [
              "modifyvm", :id,
              "--memory", memory.to_s,
              "--cpus", cpu.to_s,
              "--name", name
            ]
          end
        elsif configglobal["GLOBAL"]["vagrant_provider"] == "vmware_fusion"
        elsif configglobal["GLOBAL"]["vagrant_provider"] == "docker"
        elsif configglobal["GLOBAL"]["vagrant_provider"] == "hyperv"
        elsif configglobal["GLOBAL"]["vagrant_provider"] == "parallels"
        end
        
        # НАСТРОЙКА SSH:
        #   В более ранних версиях Vagrant для подключения к виртуальной машине использовался ключ ~/.vagrant.d/insecure_private_key. 
        #   Но теперь Vagrant выдает предупреждение, что обнаружен небезопасный ключ и заменяет его:
        #   Vagrant insecure key detected. Vagrant will automatically replace
        #   this with a newly generated keypair for better security.
        #   Этот ключ расположен в где-то в недрах директрории .vagrant (создается после первого запуска vagrant up). Посмотреть, какой ключ 
        #   будет использован, можно с помощью команды: vagrant ssh-config
        #   Можно отменить создание ssh-ключа, если определить переменную в YAML-файле с настройками insert_key = false
        # vm.ssh.username   = configvms["username"]
        # vm.ssh.password   = configvms["password"]
        # vm.ssh.keys_only  = configvms["keys_only"]
        # vm.ssh.insert_key = configvms["insert_key"]         
        
        # КОНФИГУРАЦИЯ СЕТИ:
        #   ПЕРЕНАПРАВЛЕНИЕ ПОРТОВ:
        #     настройка "forwarded_port" позволит нам открыть порт прослушивания в хост- и гостевой операционных системах. 
        #     Хост- операционная система пересылает все полученные пакеты на порт, который мы указываем для гостевой операционной системы.
        #     Эта настройка применяется для каждой из виртуальных машин.
        #     Параметр "auto_correct" означает, что если у вас где-то есть конфликт портов (пробросили на уже занятый порт), то vagrant это дело увидит и сам 
        #     исправит. Автоматически эта опция включена только для 22 порта, для портов, которые вы задаёте вручную, нужно указать эту опцию.
        #     Никогда не назначайте проброс портов на стандартные! (например, 22 на 22) Это чревато проблемами в хост- операционной системе.
        #     По-умолчанию проброс идёт ТСР протокола. Для того, чтоб проборосить UDP порт, это нужно явно указать:
        #     vm.vm.network "forwarded_port", guest: 35555, host: 12003, protocol: "udp" 
        vm.vm.network "forwarded_port", guest: configvms["port_guest"], host: configvms["port_host"], auto_correct: true
        #     Вообще говоря, перенаправления портов обычно бывает достаточно. Но для особых нужд вам может понадобиться полностью «настоящая» виртуальная машина, 
        #     к которой можно стабильно обращаться с хост-машины и к другим ресурсам в локальной сети. Такое требование фактически может быть решено путем 
        #     настройки нескольких сетевых карт, например, одна настроена в режиме частной сети, а другая - в режиме общедоступной сети.
        #     Vagrant может поддерживать сетевые модели виртуального бокса NAT, Bridge и Hostonly через файлы конфигурации.
        #   ЧАСТНАЯ СЕТЬ (Private network):
        #     С частной сетью понятно - мы делаем собственную сеть LAN, которая будет состоять из виртуальных машин. Для доступа к такой сети из хоста нужна 
        #     пробрасывать порт через Vagrantfile (или через Vbox, но через vagrant удобнее). А для доступа из реальной сети, то есть, например из другой 
        #     физической машины, мы должны будем стучаться на IP хоста. Это удобно, если создавать виртуалку для «поиграться» или если планируется использовать 
        #     виртуалку внутри сети и за NAT (например, она получит адрес от DHCP другой виртуалки, которая будет выполнять роль шлюза). IP можно не указывать, можно сделать так:
        #     vm.vm.network "private_network", type: "dhcp"
        #     и адрес назначится автоматически.
        if configvms["ip_private"]
          vm.vm.network "private_network", ip: configvms["ip_private"]
        end
        #   ПУБЛИЧНАЯ СЕТЬ (Public network):
        #     Публичная сеть означает, что виртуальная машина представлена ​​как хост в локальной сети, т.е. так, как будто появился новый сервер со своим адресом и именем.
        #     С публичной сетью нет необходимости пробрасывать порты - всё доступно по адресу виртуалки. Для всех машин в этой же подсети.
        #     Однако тут надо быть осторожным, так как это может создать некоторые проблемы с DNS и\или DHCP на основном шлюзе.
        #     Если не задать адрес, то он будет задан DHCP-сервером в реальной подсети. По факту, публичная сеть использует bridge-соединение с WAN-адаптером 
        #     хоста. Если у вас два физических адаптера (две сетевых карты, например проводная и беспроводная), то необходимо указать, какой использовать.
        if configvms["ip_public"] && configvms["ip_bridge"]
          vm.vm.network :public_network, ip: configvms["ip_public"], bridge: configvms["ip_bridge"]
        end
        
        # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
        #     Хорошей практикой является не копирование файлов проекта в виртуальную машину, а совместное использование файлов между хостом и 
        #     гостевыми операционными системами, потому что если вы удалите свою виртуальную машину, файлы будут потеряны вместе с ней.
        #     "Из коробки" vagrant синхронизирует каталог хоста с Vagrantfile в директорию /vagrant виртуальной машины.
        #     Если на хостовой машине указывать относительный путь, то корневым будет каталог с Vagrantfile. Путь на гостевой машине должен быть только абсолютный.
        #     Для того, чтоб указать дополнительный каталоги для синхронизации, нужно добавить следующую строку в Vagrantfile:
        #     vm.vm.synced_folder "src/", "/var/www/html" 
        #     Первым аргументом является папка на хост-машине, которая будет использоваться совместно с виртуальной машиной.
        #     Второй аргумент – это целевая папка внутри виртуальной машины.
        #     create: true указывает, что если целевой папки внутри виртуальной машины не существует, то необходимо создать ее автоматически.
        #     group: «www-data» и owner: «www-data» указывает владельца и группу общей папки внутри виртуальной машины. 
        #     По умолчанию большинство веб-серверов используют www-данные в качестве владельца, обращающегося к файлам.
        #     Дополнительные опции:
        #       disabled - если указать True, то синхронизация будет отключена. Удобно, если нам не нужна дефолтная синхронизация.
        #       mount_options - дополнительные параметры, которые будут переданы команде mount при монтировании
        #       type - полезная опция, которая позволяет выбрать тип синхронизации. Доступны следующие варианты:
        #         NFS (тип NFS доступен только для Linux хост- ОС);
        #         rsync;
        #         SMB (тип SMB доступен только для Windows хост- ОС);
        #         VirtualBox.
        #     Если эта опция не указана, то vagrant выберет сам подходящую.
        #   Отключаем дефолтные общие папки для каждой из виртуальных машин:
        vm.vm.synced_folder ".", "/vagrant", disabled: true
        vm.vm.synced_folder "./www", "/var/www/html", disabled: true
        vm.vm.hostname = configvms["name"]["domain"]
        vm.vm.synced_folder configvms["document_root"] , configvms["apache_document_root"] , 
          create: true, 
          owner: "www-data", 
          group: "www-data"

        # КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL:
        #   для конкретной вирутальной машины текущего элемента массива при первой инициализации
        if File.file?("#{current_dir}/config/vagrant/provision/provision-#{configvms["name"]}.sh")
          vm.vm.provision "shell", path: "#{current_dir}/config/vagrant/provision/provision-#{configvms["name"]}.sh",
            env: {
              "PHPVERSION"  => "#{configglobal["GLOBAL"]["php_version"]}",
              "DBHOST"      => "#{configvms["mysql_dbhost"]}", 
              "DBNAME"      => "#{configvms["mysql_dbname"]}", 
              "DBUSER"      => "#{configvms["mysql_dbuser"]}", 
              "DBPASSWD"    => "#{configvms["mysql_dbpasswd"]}"
            }
        end
        if configvms["name"] == "mysql"
          configvms["mysql_database"].each do |configmysql|
            vm.vm.provision "shell", path: "#{current_dir}/config/vagrant/provision/provision-mysql-createdb.sh",
              env: {
                "DB_ROOT_USER"    => "#{configvms["mysql_dbuser"]}", 
                "DB_ROOT_PASSWD"  => "#{configvms["mysql_dbpasswd"]}",
                "DBNAME"          => "#{configmysql["dbname"]}",
                "DBUSER"          => "#{configmysql["dbuser"]}", 
                "DBPASSWD"        => "#{configmysql["dbpwd"]}"
              }
          end
        end
        if configvms["name"] == "dev"
          configvms["VirtualHost"].each do |virtualhost|
            vm.vm.provision "shell", path: "#{current_dir}/config/vagrant/provision/provision-dev-virtualhost-create.sh",
              env: {
                "ServerAdmin"   => "#{virtualhost["ServerAdmin"]}",
                "ServerName"    => "#{virtualhost["ServerName"]}",
                "ServerAlias"   => "#{virtualhost["ServerAlias"]}",
                "DocumentRoot"  => "#{virtualhost["DocumentRoot"]}",
              }
          end
          vm.vm.provision "shell", path: "#{current_dir}/config/vagrant/provision/provision-dev-virtualhost-register.sh"
        end
        #   для конкретной вирутальной машины текущего элемента массива при каждой инициализации
        #     privileged - определяет, от какого пользователя запускать команду. По-умолчанию установленно True, что запустит скритп от root. Если команда должна 
        #     запускаться от стандартного пользователя (vagrant), то установите значения False.
        if File.file?("#{current_dir}/config/vagrant/provision/vagrant-up-#{configvms["name"]}.sh")
          vm.vm.provision "shell", path: "#{current_dir}/config/vagrant/provision/vagrant-up-#{configvms["name"]}.sh",
            env: {
            },
            run: "always", 
            privileged: true
        end

        # ПЕРСОНАЛЬНАЯ МАГИЯ:
        if configvms["name"] == "git"
          # ТРИГГЕРЫ:
          #   ...
          # ПРОБРОС ПОРТОВ:
          #   ...
          # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
          #   ...
          # ДОПОЛНИТЕЛЬНАЯ КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL
          # при первой загрузке
          #   ...
          #   при каждой загрузке:
          #   ...      
                
        elsif configvms["name"] == "build"
          # ТРИГГЕРЫ:
          #   ...
          # ПРОБРОС ПОРТОВ:
          #   ...
          # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
          #   ...
          # ДОПОЛНИТЕЛЬНАЯ КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL
          # при первой загрузке
          #   ...
          #   при каждой загрузке:
          #   ...     
        
        elsif configvms["name"] == "dev"
          # ТРИГГЕРЫ:
          #   ...
          # ПРОБРОС ПОРТОВ:
          #   ...
          # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
          # vm.vm.synced_folder configvms["vhosts_dir"] , "/var/tmp/devops-vhosts", create: true
          # ДОПОЛНИТЕЛЬНАЯ КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL
          #   при первой загрузке
          #   ...
          #   при каждой загрузке:
          #   ...  
        
        elsif configvms["name"] == "mysql"
          # ТРИГГЕРЫ:
          vm.trigger.before :halt do |trigger|
            trigger.name = "\e[34m vagrant halt #{configvms["name"]} VM\e[0m"
            trigger.info = "\e[34m Останавливаем MySQL сервер баз данных \e[0m"
            trigger.run_remote  = {path: "#{current_dir}/config/vagrant/provision/vagrant-halt-mysql-before.sh"}
          end
          # ПРОБРОС ПОРТОВ:
          #   Дополнительно проброс портов для виртуальной машины "MySQL"
          #   Для MySQL стандартный порт 3306, значения берутся из YAML-файла с настройками. 
          #   Если у вас уже используется этот порт, вы можете изменить его.
          #   Для веб-приложений, например для phpmyadmin, значения берутся из YAML-файла с настройками.
          vm.vm.network "forwarded_port", guest: configvms["mysql_guest"], host: configvms["mysql_guest"]
          # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
          #   ...
          # ДОПОЛНИТЕЛЬНАЯ КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL
          # при первой загрузке:
          #   ...      
          # при каждой загрузке:
          #   ...
        elsif configvms["name"] == "postgresql"
          # ТРИГГЕРЫ:
          #   ...
          # ПРОБРОС ПОРТОВ:
          #   ...
          # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
          #   ...
          # ДОПОЛНИТЕЛЬНАЯ КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL
          # при первой загрузке
          #   ...
          #   при каждой загрузке:
          #   ...
                   
        end                     
      end
    end
  end
  
  # КОНФИГУРАЦИЯ ВИРТУАЛЬНОЙ МАШИНЫ С ПОМОЩЬЮ SHELL:
  #   для каждой из вирутальных машин при первой инициализации
  config.vm.provision "shell", path: "#{current_dir}/config/vagrant/provision/provision.sh",
    env: {
    }
end