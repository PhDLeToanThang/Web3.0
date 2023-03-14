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
echo '[PHP]' >> /etc/php/8.1/fpm/php.ini
echo 'engine = On' >> /etc/php/8.1/fpm/php.ini
echo 'short_open_tag = Off' >> /etc/php/8.1/fpm/php.ini
echo 'precision = 14' >> /etc/php/8.1/fpm/php.ini
echo 'output_buffering = 4096' >> /etc/php/8.1/fpm/php.ini
echo 'zlib.output_compression = Off' >> /etc/php/8.1/fpm/php.ini
echo 'implicit_flush = Off' >> /etc/php/8.1/fpm/php.ini
echo 'unserialize_callback_func =' >> /etc/php/8.1/fpm/php.ini
echo 'serialize_precision = -1' >> /etc/php/8.1/fpm/php.ini
echo 'disable_functions = ' >> /etc/php/8.1/fpm/php.ini
echo 'disable_classes =' >> /etc/php/8.1/fpm/php.ini
echo 'zend.enable_gc = On' >> /etc/php/8.1/fpm/php.ini
echo 'zend.exception_ignore_args = On' >> /etc/php/8.1/fpm/php.ini
echo 'zend.exception_string_param_max_len = 0' >> /etc/php/8.1/fpm/php.ini
echo '#Add the following line right below the [PHP] line:' >> /etc/php/8.1/fpm/php.ini
echo 'zend_extension=/usr/lib/php/ioncube/ioncube_loader_lin_8.1.so' >> /etc/php/8.1/fpm/php.ini
echo 'expose_php = Off' >> /etc/php/8.1/fpm/php.ini
echo 'max_execution_time = 360' >> /etc/php/8.1/fpm/php.ini
echo 'max_input_time = 120' >> /etc/php/8.1/fpm/php.ini
echo 'memory_limit = 1200M' >> /etc/php/8.1/fpm/php.ini
echo 'error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT' >> /etc/php/8.1/fpm/php.ini
echo 'display_errors = Off' >> /etc/php/8.1/fpm/php.ini
echo 'display_startup_errors = Off' >> /etc/php/8.1/fpm/php.ini
echo 'log_errors = On' >> /etc/php/8.1/fpm/php.ini
echo 'ignore_repeated_errors = Off' >> /etc/php/8.1/fpm/php.ini
echo 'ignore_repeated_source = Off' >> /etc/php/8.1/fpm/php.ini
echo 'report_memleaks = On' >> /etc/php/8.1/fpm/php.ini
echo 'variables_order = "GPCS"' >> /etc/php/8.1/fpm/php.ini
echo 'request_order = "GP"' >> /etc/php/8.1/fpm/php.ini
echo 'register_argc_argv = Off' >> /etc/php/8.1/fpm/php.ini
echo 'max_input_nesting_level = 64' >> /etc/php/8.1/fpm/php.ini
echo 'max_input_vars = 5000' >> /etc/php/8.1/fpm/php.ini
echo 'auto_globals_jit = On' >> /etc/php/8.1/fpm/php.ini
echo 'post_max_size = 4096M' >> /etc/php/8.1/fpm/php.ini
echo 'auto_prepend_file =' >> /etc/php/8.1/fpm/php.ini
echo 'auto_append_file =' >> /etc/php/8.1/fpm/php.ini
echo 'default_mimetype = "text/html"' >> /etc/php/8.1/fpm/php.ini
echo 'default_charset = "UTF-8"' >> /etc/php/8.1/fpm/php.ini
echo 'doc_root =' >> /etc/php/8.1/fpm/php.ini
echo 'user_dir =' >> /etc/php/8.1/fpm/php.ini
echo 'enable_dl = Off' >> /etc/php/8.1/fpm/php.ini
echo 'file_uploads = On' >> /etc/php/8.1/fpm/php.ini
echo 'upload_max_filesize = 4096M' >> /etc/php/8.1/fpm/php.ini
echo 'max_file_uploads = 20' >> /etc/php/8.1/fpm/php.ini
echo 'allow_url_fopen = On' >> /etc/php/8.1/fpm/php.ini
echo 'allow_url_include = Off' >> /etc/php/8.1/fpm/php.ini
echo 'default_socket_timeout = 60' >> /etc/php/8.1/fpm/php.ini
echo 'extension=bz2' >> /etc/php/8.1/fpm/php.ini
echo 'extension=curl' >> /etc/php/8.1/fpm/php.ini
echo 'extension=fileinfo' >> /etc/php/8.1/fpm/php.ini
echo 'extension=intl' >> /etc/php/8.1/fpm/php.ini
echo 'extension=mbstring' >> /etc/php/8.1/fpm/php.ini
echo 'extension=openssl' >> /etc/php/8.1/fpm/php.ini
echo '[CLI Server]' >> /etc/php/8.1/fpm/php.ini
echo 'cli_server.color = On' >> /etc/php/8.1/fpm/php.ini
echo '[Date]' >> /etc/php/8.1/fpm/php.ini
echo 'date.default_latitude = 21.028511' >> /etc/php/8.1/fpm/php.ini
echo 'date.default_longitude = 105.804817' >> /etc/php/8.1/fpm/php.ini
echo 'date.timezone = Asia/Ho_Chi_Minh' >> /etc/php/8.1/fpm/php.ini
echo '[filter]' >> /etc/php/8.1/fpm/php.ini
echo '[iconv]' >> /etc/php/8.1/fpm/php.ini
echo '[imap]' >> /etc/php/8.1/fpm/php.ini
echo '[intl]' >> /etc/php/8.1/fpm/php.ini
echo '[sqlite3]' >> /etc/php/8.1/fpm/php.ini
echo '[Pcre]' >> /etc/php/8.1/fpm/php.ini
echo '[Pdo]' >> /etc/php/8.1/fpm/php.ini
echo '[Pdo_mysql]' >> /etc/php/8.1/fpm/php.ini
echo 'pdo_mysql.default_socket=' >> /etc/php/8.1/fpm/php.ini
echo '[Phar]' >> /etc/php/8.1/fpm/php.ini
echo '[mail function]' >> /etc/php/8.1/fpm/php.ini
echo 'SMTP = localhost' >> /etc/php/8.1/fpm/php.ini
echo 'smtp_port = 25' >> /etc/php/8.1/fpm/php.ini
echo 'mail.add_x_header = Off' >> /etc/php/8.1/fpm/php.ini
echo '[ODBC]' >> /etc/php/8.1/fpm/php.ini
echo 'odbc.allow_persistent = On' >> /etc/php/8.1/fpm/php.ini
echo 'odbc.check_persistent = On' >> /etc/php/8.1/fpm/php.ini
echo 'odbc.max_persistent = -1' >> /etc/php/8.1/fpm/php.ini
echo 'odbc.max_links = -1' >> /etc/php/8.1/fpm/php.ini
echo 'odbc.defaultlrl = 4096' >> /etc/php/8.1/fpm/php.ini
echo 'odbc.defaultbinmode = 1' >> /etc/php/8.1/fpm/php.ini
echo '[MySQLi]' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.max_persistent = -1' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.allow_persistent = On' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.max_links = -1' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.default_port = 3306' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.default_socket =' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.default_host =' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.default_user =' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.default_pw =' >> /etc/php/8.1/fpm/php.ini
echo 'mysqli.reconnect = Off' >> /etc/php/8.1/fpm/php.ini
echo '[mysqlnd]' >> /etc/php/8.1/fpm/php.ini
echo 'mysqlnd.collect_statistics = On' >> /etc/php/8.1/fpm/php.ini
echo 'mysqlnd.collect_memory_statistics = Off' >> /etc/php/8.1/fpm/php.ini
echo '[OCI8]' >> /etc/php/8.1/fpm/php.ini
echo '[PostgreSQL]' >> /etc/php/8.1/fpm/php.ini
echo 'pgsql.allow_persistent = On' >> /etc/php/8.1/fpm/php.ini
echo 'pgsql.auto_reset_persistent = Off' >> /etc/php/8.1/fpm/php.ini
echo 'pgsql.max_persistent = -1' >> /etc/php/8.1/fpm/php.ini
echo 'pgsql.max_links = -1' >> /etc/php/8.1/fpm/php.ini
echo 'pgsql.ignore_notice = 0' >> /etc/php/8.1/fpm/php.ini
echo 'pgsql.log_notice = 0' >> /etc/php/8.1/fpm/php.ini
echo '[bcmath]' >> /etc/php/8.1/fpm/php.ini
echo 'bcmath.scale = 0' >> /etc/php/8.1/fpm/php.ini
echo '[browscap]' >> /etc/php/8.1/fpm/php.ini
echo '[Session]' >> /etc/php/8.1/fpm/php.ini
echo 'session.save_handler = files' >> /etc/php/8.1/fpm/php.ini
echo 'session.use_strict_mode = 0' >> /etc/php/8.1/fpm/php.ini
echo 'session.use_cookies = 1' >> /etc/php/8.1/fpm/php.ini
echo 'session.use_only_cookies = 1' >> /etc/php/8.1/fpm/php.ini
echo 'session.name = PHPSESSID' >> /etc/php/8.1/fpm/php.ini
echo 'session.auto_start = 0' >> /etc/php/8.1/fpm/php.ini
echo 'session.cookie_lifetime = 0' >> /etc/php/8.1/fpm/php.ini
echo 'session.cookie_path = /' >> /etc/php/8.1/fpm/php.ini
echo 'session.cookie_domain =' >> /etc/php/8.1/fpm/php.ini
echo 'session.cookie_httponly = on' >> /etc/php/8.1/fpm/php.ini
echo 'session.cookie_samesite =' >> /etc/php/8.1/fpm/php.ini
echo 'session.serialize_handler = php' >> /etc/php/8.1/fpm/php.ini
echo 'session.gc_probability = 0' >> /etc/php/8.1/fpm/php.ini
echo 'session.gc_divisor = 1000' >> /etc/php/8.1/fpm/php.ini
echo 'session.gc_maxlifetime = 1440' >> /etc/php/8.1/fpm/php.ini
echo 'session.referer_check =' >> /etc/php/8.1/fpm/php.ini
echo 'session.cache_limiter = nocache' >> /etc/php/8.1/fpm/php.ini
echo 'session.cache_expire = 180' >> /etc/php/8.1/fpm/php.ini
echo 'session.use_trans_sid = 0' >> /etc/php/8.1/fpm/php.ini
echo 'session.sid_length = 26' >> /etc/php/8.1/fpm/php.ini
echo 'session.trans_sid_tags = "a=href,area=href,frame=src,form="' >> /etc/php/8.1/fpm/php.ini
echo 'session.sid_bits_per_character = 5' >> /etc/php/8.1/fpm/php.ini
echo '[Assertion]' >> /etc/php/8.1/fpm/php.ini
echo 'zend.assertions = -1' >> /etc/php/8.1/fpm/php.ini
echo '[COM]' >> /etc/php/8.1/fpm/php.ini
echo '[mbstring]' >> /etc/php/8.1/fpm/php.ini
echo '[gd]' >> /etc/php/8.1/fpm/php.ini
echo '[exif]' >> /etc/php/8.1/fpm/php.ini
echo '[Tidy]' >> /etc/php/8.1/fpm/php.ini
echo 'tidy.clean_output = Off' >> /etc/php/8.1/fpm/php.ini
echo '[soap]' >> /etc/php/8.1/fpm/php.ini
echo 'soap.wsdl_cache_enabled=1' >> /etc/php/8.1/fpm/php.ini
echo 'soap.wsdl_cache_dir="/tmp"' >> /etc/php/8.1/fpm/php.ini
echo 'soap.wsdl_cache_ttl=86400' >> /etc/php/8.1/fpm/php.ini
echo 'soap.wsdl_cache_limit = 5' >> /etc/php/8.1/fpm/php.ini
echo '[sysvshm]' >> /etc/php/8.1/fpm/php.ini
echo '[ldap]' >> /etc/php/8.1/fpm/php.ini
echo 'ldap.max_links = -1' >> /etc/php/8.1/fpm/php.ini
echo '[dba]' >> /etc/php/8.1/fpm/php.ini
echo '[opcache]' >> /etc/php/8.1/fpm/php.ini
echo '[curl]' >> /etc/php/8.1/fpm/php.ini
echo '[openssl]' >> /etc/php/8.1/fpm/php.ini
echo '[ffi]' >> /etc/php/8.1/fpm/php.ini

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
