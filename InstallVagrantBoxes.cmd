"C:\Program Files (x86)\GnuWin32\bin\wget.exe" -q -O- http://taurus.chelnik.ru:8080/share.cgi?ssid=f7150e98481e478daece3fd43e9b9885 --output-document="C:\Development\GITHUB.My-PP\vagrant-multi-machine\VirtualBox\nnn.nn"

pause

vagrant box add ubuntu/focal64 /VirtualBox/ubuntu-focal64-20220724.0.0/metadata.json
vagrant box add ubuntu/focal64 /VirtualBox/ubuntu-focal64-20220804.0.0/metadata.json
vagrant box add ubuntu/xenial64 /VirtualBox/ubuntu-xenial64-20211001.0.0/metadata.json

pause
exit