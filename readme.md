# Serveryzer

Serveryzer - клієнт-серверне програмне забезпечення, що забезпечуе відображення актуальної інформації.


## Інструкція для встановлення додаткових компонент
Встановлення прогрмного забезпечення Apache на операцийну систему CentOS 7
```sh
$ sudo yum install httpd
```
## Інсталяція програми
Backend частина Serveryzer



##### Frontend частина Serveryzer
**Крок 1 — Перевірка веб-сервера**
```sh
$ sudo systemctl start httpd
$ sudo systemctl status httpd
```
**Крок 2 — Налаштування віртуальних хостів**
1. Створемо директорії `html` та `log` для `t1.tss2020.site`
    ```sh
    $ sudo mkdir -p /var/www/t1.tss2020.site/html
    $ sudo mkdir -p /var/www/t1.tss2020.site/log
    ```
2. Налаштуесо правила запису
    ```sh
    $ sudo chown -R $USER:$USER /var/www/t1.tss2020.site/html
    $ sudo chmod -R 755 /var/www
    ```
3. Копіюємо вміст папки `front` до `var/www/t1.tss2020.site/html`
4. Створемо директорії `sites-available` та `sites-enabled` для Apache
    ```sh
    $ sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
    ```
5. Відредагуємо файл `httpd.conf`
    ```sh
    $ sudo vi /etc/httpd/conf/httpd.conf
    ```
    В кінці додати рядок
    ```sh
    IncludeOptional sites-enabled/*.conf
    ```
6. Створемо файл `t1.tss2020.site.conf`
    ```sh
    $ sudo vi /etc/httpd/sites-available/t1.tss2020.site.conf
    ```
    з наступним текстом
    ```sh
    <VirtualHost *:80>
        ServerName www.t1.tss2020.site
        ServerAlias t1.tss2020.site
        DocumentRoot /var/www/t1.tss2020.site/html
        ErrorLog /var/www/t1.tss2020.site/log/error.log
        CustomLog /var/www/t1.tss2020.site/log/requests.log combined
    </VirtualHost>
    ```
7. Створемо посилання на файл `t1.tss2020.site.conf` в виректоріях s`ites-available` та `sites-enabled`
    ```sh
    $ sudo ln -s /etc/httpd/sites-available/t1.tss2020.site.conf
    /etc/httpd/sites-enabled/t1.tss2020.site.conf
    ```

**Крок 3 — Налаштування SELinux**
Виконайте настпуну команду для встановлення універсальних політик Apache
```sh
$ sudo setsebool -P httpd_unified 1
```
**Крок 4 — Перезапуск Apache**
```sh
$ sudo systemctl restart httpd
```
## Управління версіями
Для управління версіями ми використовуємо Git.

## Технології

Під час розроблення Serveryzer були використані технології:

* **Javalin** - середовище фреймверк для backend
* **Java** - awesome web-based text editor
* **Flutter** - Фреймворк, створений на мові програмування Dart. Використовуется для створення front-end частини програмного продукту
* **Git** - система контролю версій

### Автори
* Project manager - Гирявенко Дмитрій
* Back deeloper - Трусов Богдан
* Back deeloper - Журавльов Юрій
* Back deeloper - Порошин Дмитро
* Front developer - Порошин Дмитро
* QA lead - Чечіль Тимофій
* TA lead - Котелевський Кирило


### License
The MIT License (MIT)

Copyright © «2020» «IN71_01-06»

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files Serveryzer, to deal in the Serveryzer without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Serveryzer, and to permit persons to whom the Serveryzer is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Serveryzer.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
