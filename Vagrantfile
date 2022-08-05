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
  # ПРОХОДИМ ПО ЭЛЕМЕНТАМ МАССИВА "VMs" ИЗ YAML-ФАЙЛА С НАСТРОЙКАМИ:
  #   глобальная инициализация будет выполняться сначала для каждой из виртуальных машин, а затем будет инициализация 
  #   с ограниченной областью действия. Поместив контроллер в конец списка, он будет последним, для которого выполняется 
  #   инициализация. Вы можете упорядочить загрузку, изменив порядок из списка и создав условия. 
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
        
        # НАСТРОЙКА SSH
        # vm.ssh.username   = configvms["username"]
        # vm.ssh.password   = configvms["password"]
        # vm.ssh.keys_only  = configvms["keys_only"]
        # vm.ssh.insert_key = configvms["insert_key"]         
        
        # КОНФИГУРАЦИЯ СЕТИ:
        #   перенаправление портов:
        #     следующая настройка позволит нам открыть порт прослушивания в хост- и гостевой операционных системах. 
        #     Хост- операционная система пересылает все полученные пакеты на порт, который мы указываем для гостевой операционной системы.
        #     Эта настройка применяется для каждой из виртуальных машин.
        vm.vm.network "forwarded_port", guest: configvms["port_guest"], host: configvms["port_host"]
        #   частная сеть:
        vm.vm.network "private_network", ip: configvms["ip"]
        
        # СИНХРОНИЗАЦИЯ ФАЙЛОВ ПРОЕКТА:
        #   хорошей практикой является не копирование файлов проекта в виртуальную машину, а совместное использование файлов между хостом и 
        #   гостевыми операционными системами, потому что если вы удалите свою виртуальную машину, файлы будут потеряны с ней.
        #   Первым аргументом является папка на хост-машине, которая будет использоваться совместно с виртуальной машиной.
        #   Второй аргумент – это целевая папка внутри виртуальной машины.
        #   create: true указывает, что если целевой папки внутри виртуальной машины не существует, то необходимо создать ее автоматически.
        #   group: «www-data» и owner: «www-data» указывает владельца и группу общей папки внутри виртуальной машины. 
        #   По умолчанию большинство веб-серверов используют www-данные в качестве владельца, обращающегося к файлам.
        #   Отключаем дефолтные общие папки для каждой из виртуальных машин
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