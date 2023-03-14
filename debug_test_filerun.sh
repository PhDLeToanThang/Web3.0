#!/bin/bash
clear
cd ~
############### Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: filerun.company.vn"   # Đổi địa chỉ web thứ nhất Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e FQDN
echo "dbname: e.g: filerundata"   # Tên DBNane
read -e dbname
echo "dbuser: e.g: userfilerundata"   # Tên User access DB lmsatcuser
read -e dbuser
echo "Database Password: e.g: P@$$w0rd-1.22"
read -s dbpass
echo "phpmyadmin folder name: e.g: filerundbadmin"   # Đổi tên thư mục phpmyadmin khi add link symbol vào Website 
read -e phpmyadmin
echo "filerun Folder Data: e.g: filerundata"   # Tên Thư mục chưa Data vs Cache
read -e FOLDERDATA
echo "dbtype name: e.g: mariadb"   # Tên kiểu Database
read -e dbtype
echo "dbhost name: e.g: localhost"   # Tên Db host connector
read -e dbhost
echo "Your email for access control SSL/TLS from Let's Encrypt: e.g: youremail@filerun.com" # Địa chỉ email của bạn để quản lý SSL/TLS
read -e youremail

GitFILERUNversion="FileRun.zip"

echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit
else

# Download ioncube_loaders_lin_x86-64.tar.gz to /opt folder
cd /opt

#Filerun uses ionCube to encrypt its PHP file, so we need to install the ionCube PHP loader to decrypt the PHP files. Dowload ionCube loaders.
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

#Extract it to /usr/lib/php/:
sudo tar -xzf ioncube_loaders_lin_x86-64.tar.gz -C /usr/lib/php

#Step 4: #If you use Nginx, edit the php.ini file: Open PHP-FPM config file. Safe a PHP.ini old before create a new PHP 8.1 .ini configure
cp /etc/php/8.1/fpm/php.ini /etc/php/8.1/fpm/php_old.ini
sudo nano /etc/php/8.1/fpm/php.ini

#Add/Update the values as shown. You may change it as per your requirement.
# if new php.ini configure then clear sign sharp # comment
[PHP]
engine = On
short_open_tag = Off
precision = 14
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func =
serialize_precision = -1
disable_functions = 
disable_classes =
zend.enable_gc = On
zend.exception_ignore_args = On
zend.exception_string_param_max_len = 0
#Add the following line right below the [PHP] line:
zend_extension=/usr/lib/php/ioncube/ioncube_loader_lin_8.1.so
expose_php = Off
max_execution_time = 360
max_input_time = 120
memory_limit = 1200M
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = Off
display_startup_errors = Off
log_errors = On
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
variables_order = "GPCS"
request_order = "GP"
register_argc_argv = Off
max_input_nesting_level = 64
max_input_vars = 5000
auto_globals_jit = On
post_max_size = 4096M
auto_prepend_file =
auto_append_file =
default_mimetype = "text/html"
default_charset = "UTF-8"
doc_root =
user_dir =
enable_dl = Off
file_uploads = On
upload_max_filesize = 4096M
max_file_uploads = 20
allow_url_fopen = On
allow_url_include = Off
default_socket_timeout = 60
extension=bz2
extension=curl
;extension=ffi
;extension=ftp
extension=fileinfo
;extension=gd
;extension=gettext
;extension=gmp
extension=intl
;extension=imap
;extension=ldap
extension=mbstring
;extension=exif      ; Must be after mbstring as it depends on it
;extension=mysqli
;extension=oci8_12c  ; Use with Oracle Database 12c Instant Client
;extension=oci8_19  ; Use with Oracle Database 19 Instant Client
;extension=odbc
extension=openssl
;extension=pdo_firebird
;extension=pdo_mysql
;extension=pdo_oci
;extension=pdo_odbc
;extension=pdo_pgsql
;extension=pdo_sqlite
;extension=pgsql
;extension=shmop
;extension=snmp
;extension=soap
;extension=sockets
;extension=sodium
;extension=sqlite3
;extension=tidy
;extension=xsl
;zend_extension=opcache
[CLI Server]
cli_server.color = On

[Date]
date.default_latitude = 21.028511
date.default_longitude = 105.804817
date.timezone = Asia/Ho_Chi_Minh

[filter]
[iconv]
[imap]
[intl]
[sqlite3]
[Pcre]
[Pdo]
[Pdo_mysql]
pdo_mysql.default_socket=
[Phar]
[mail function]
SMTP = localhost
; https://php.net/smtp-port
smtp_port = 25
;sendmail_from = me@example.com
;sendmail_path =
;mail.force_extra_parameters =
mail.add_x_header = Off
;mail.log = syslog
[ODBC]
odbc.allow_persistent = On
odbc.check_persistent = On
odbc.max_persistent = -1
odbc.max_links = -1
odbc.defaultlrl = 4096
odbc.defaultbinmode = 1
[MySQLi]
mysqli.max_persistent = -1
mysqli.allow_persistent = On
mysqli.max_links = -1
mysqli.default_port = 3306
mysqli.default_socket =
mysqli.default_host =
mysqli.default_user =
mysqli.default_pw =
mysqli.reconnect = Off
[mysqlnd]
mysqlnd.collect_statistics = On
mysqlnd.collect_memory_statistics = Off
[OCI8]
[PostgreSQL]
pgsql.allow_persistent = On
pgsql.auto_reset_persistent = Off
pgsql.max_persistent = -1
pgsql.max_links = -1
pgsql.ignore_notice = 0
pgsql.log_notice = 0
[bcmath]
bcmath.scale = 0
[browscap]
[Session]
session.save_handler = files
session.use_strict_mode = 0
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly = on
session.cookie_samesite =
session.serialize_handler = php
session.gc_probability = 0
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.referer_check =
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.sid_length = 26
session.trans_sid_tags = "a=href,area=href,frame=src,form="
session.sid_bits_per_character = 5
[Assertion]
zend.assertions = -1
[COM]
[mbstring]
[gd]
[exif]
[Tidy]
tidy.clean_output = Off
[soap]
soap.wsdl_cache_enabled=1
soap.wsdl_cache_dir="/tmp"
soap.wsdl_cache_ttl=86400
soap.wsdl_cache_limit = 5
[sysvshm]
[ldap]
ldap.max_links = -1
[dba]
[opcache]
[curl]
[openssl]
[ffi]


#Save and close the file. We need to create a second PHP ini file:
sudo nano /etc/php/8.1/fpt/conf.d/10-ioncube.ini
#Add the following lines. This is to change some of the default PHP configurations:
expose_php = Off
error_reporting = E_ALL & ~E_NOTICE
display_errors = Off
display_startup_errors = Off
log_errors = On
ignore_repeated_errors = Off
allow_url_fopen = On
allow_url_include = Off
variables_order = "GPCS"
allow_webdav_methods = On
memory_limit = 1200M
max_execution_time = 600
output_buffering = Off
output_handler = ""
zlib.output_compression = Off
zlib.output_handler = ""
safe_mode = Off
register_globals = Off
magic_quotes_gpc = Off
upload_max_filesize = 100M
post_max_size = 4096M
enable_dl = Off
disable_functions = ""
disable_classes = ""
session.save_handler = files
session.use_cookies = 1
session.use_only_cookies = 1
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_httponly = 1
date.timezone = "Asia/Ho_Chi_Minh"

#Save and close the file. Then restart Nginx and PHP8.1-FPM.
sudo systemctl restart nginx php8.1-fpm.service


#Step 6. Download & Install FileRun to /opt folder
#We will be using Git to install/update the FileRun Core Application 
sudo apt install git
cd /opt

sudo apt-get -y install wget
#Run the following command to download FileRun package.
#Download the FileRun Code and Unzip 

wget -O $GitFILERUNversion https://filerun.com/download-latest
sudo apt install unzip
sudo mkdir -p /var/www/$FQDN/
sudo unzip $GitFILERUNversion -d /var/www/$FQDN/
sudo chown www-data:www-data /var/www/$FQDN/ -R
sudo mysql
sudo mariadb


#Step 7. Create FileRun Database
#Log into MySQL and create database for FileRun.
#!/bin/bash
mysql -uroot -prootpassword -e "CREATE DATABASE $dbname CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -uroot -prootpassword -e "CREATE USER '$dbuser'@'$dbhost' IDENTIFIED BY '$dbpass'";
mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'$dbhost'";
mysql -uroot -prootpassword -e "FLUSH PRIVILEGES";
mysql -uroot -prootpassword -e "SHOW DATABASES";
mysql -uroot -prootpassword -e "exit";

#create database filerun;
#create user filerun@localhost identified by 'your-password';
#grant all privileges on filerun.* to filerun@localhost;
#flush privileges;


#Step 8. Configure NGINX
#Next, you will need to create an Nginx virtual host configuration file to host SEO:
#$ nano /etc/nginx/conf.d/$FQDN.conf
echo 'server {'  >> /etc/nginx/conf.d/$FQDN.conf
echo '    root '/var/www/html/${FQDN}';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    index index.php index.html index.htm;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    server_name '${FQDN}';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    client_max_body_size 512M;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    autoindex off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location / {'>> /etc/nginx/conf.d/$FQDN.conf
echo '        try_files $uri $uri/ =404;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    client_max_body_size 500M;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        #enable gzip compression:'>> /etc/nginx/conf.d/$FQDN.conf
echo '    gzip on;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    gzip_vary on;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    gzip_min_length 1000;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    gzip_comp_level 5;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    gzip_types application/json text/css application/x-javascript application/javascript image/svg+xml;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    gzip_proxied any;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    # A long browser cache lifetime can speed up repeat visits to your page:'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {'>> /etc/nginx/conf.d/$FQDN.conf
echo '    access_log        off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    log_not_found     off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    expires           360d;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    # disable access to hidden files'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location ~ /\.ht {'>> /etc/nginx/conf.d/$FQDN.conf
echo '    access_log off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    log_not_found off;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    deny all;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location /dataroot/ {'>> /etc/nginx/conf.d/$FQDN.conf
echo '      internal;'>> /etc/nginx/conf.d/$FQDN.conf
echo '      alias '/var/www/html/$FOLDERDATA/';'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '    location ~ [^/].php(/|$) {'>> /etc/nginx/conf.d/$FQDN.conf
echo '        include snippets/fastcgi-php.conf;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        fastcgi_pass unix:/run/php/php8.1-fpm.sock;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;'>> /etc/nginx/conf.d/$FQDN.conf
echo '        include fastcgi_params;'>> /etc/nginx/conf.d/$FQDN.conf
echo '    }'>> /etc/nginx/conf.d/$FQDN.conf
echo '	  location ~ ^/(doc|sql|setup)/{'>> /etc/nginx/conf.d/$FQDN.conf
echo '		deny all;'>> /etc/nginx/conf.d/$FQDN.conf
echo '	  }'>> /etc/nginx/conf.d/$FQDN.conf
echo '}'>> /etc/nginx/conf.d/$FQDN.conf

Fi
