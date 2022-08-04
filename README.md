<h1 align="center">
	<a  href="#vagrant" class="anchor" name="start"></a>
  Vagrant Multi-Machine<br />Создаём несколько преднастроенных машин используя один Vagrantfile
</h1>

## Системные требования:
- Устройство:
  - с предустановленной Windows Server, Windows 10 Корпоративная, Pro или для образовательных учреждений (роль Hyper-V невозможно установить в Windows 10 Домашняя.);
  - 64-разрядный процессор с поддержкой преобразования адресов второго уровня (SLAT).
  - ЦП должен поддерживать расширения режима мониторинга виртуальной машины (VT-c на процессорах Intel).
  - Не менее 8 ГБ оперативной памяти.
- Git;
- Система виртуализации:
  - Virtualbox;
  - Hyper-V.
- Vagrant.

## Если не установлен Git:
- [Установка в Windows](https://github.com/My-PP/readme)
- [Первоначальная настройка Git](https://github.com/My-PP/readme)
- [Устанавливаем SSH-ключи](https://github.com/My-PP/readme)

## Virtualbox:
- [Установка в Windows](https://github.com/My-PP/readme)

## Hyper-V:
- [Проверьте следующие требования](https://github.com/My-PP/readme)
- [Включение аппаратной виртуализации](https://github.com/My-PP/readme)
- [Включение Hyper-V с помощью PowerShell](https://github.com/My-PP/readme)
- [Включение Hyper-V с помощью CMD и DISM](https://github.com/My-PP/readme)
- [Включение роли Hyper-V через раздел "Параметры"](https://github.com/My-PP/readme)

## Vagrant
- [Установка в Windows](https://github.com/My-PP/readme)
- альтернативная ссылка, если получаем 404;

## Установка Vagrant Multi-Machine
- склонировать репозиторий
- ...

Для того, чтобы увидеть наши приложения в браузере: открыть файл 'C:\Windows\System32\drivers\etc\hosts' в режиме администратора, чтобы иметь возможность редактировать его, и добавь туда следующие строчки: <br />
- 127.0.0.1 wordpress.local
- 127.0.0.1 drupal.local

## Приложения:
- localhost:8080
- localhost:8080/phpmyadmin
- wordpress.local:8080
- drupal.local:8080