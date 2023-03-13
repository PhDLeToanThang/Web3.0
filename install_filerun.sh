wget -O FileRun.zip https://filerun.com/download-latest
sudo apt install unzip
sudo mkdir -p /var/www/filerun/
sudo unzip FileRun.zip -d /var/www/filerun/
sudo chown www-data:www-data /var/www/filerun/ -R
sudo mysql
sudo mariadb
create database filerun;
create user filerun@localhost identified by 'your-password';
grant all privileges on filerun.* to filerun@localhost;
flush privileges;
exit;

sudo nano /etc/nginx/conf.d/filerun.conf
server {
    listen [::]:80;
    listen 80;
    server_name filerun.example.com;

    access_log /var/log/nginx/filerun.access.log;
    error_log /var/log/nginx/filerun.error.log;
  
    root /var/www/filerun/;
    index index.php index.html;

   location / {
      try_files $uri $uri/ /index.php;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;

    client_max_body_size 500M;

    location = /50x.html {
      root /usr/share/nginx/html;
    }

    location ~ \.php$ {
      fastcgi_pass unix:/run/php/php7.4-fpm.sock;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include fastcgi_params;
      include snippets/fastcgi-php.conf;
    }

    #enable gzip compression:
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_comp_level 5;
    gzip_types application/json text/css application/x-javascript application/javascript image/svg+xml;
    gzip_proxied any;

    # A long browser cache lifetime can speed up repeat visits to your page:
    location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {
         access_log        off;
         log_not_found     off;
         expires           360d;
    }

    # disable access to hidden files
    location ~ /\.ht {
        access_log off;
        log_not_found off;
        deny all;
    }
}

sudo nginx -t
sudo systemctl reload nginx

#Step 4: Install and Enable PHP Modules
#Run the following commands to install PHP modules required or recommended by FileRun:
sudo apt install imagemagick ffmpeg php-imagick php7.4-mysql php7.4-fpm php7.4-common php7.4-gd php7.4-json php7.4-curl  php7.4-zip php7.4-xml php7.4-mbstring php7.4-bz2 php7.4-intl

#Filerun uses ionCube to encrypt its PHP file, so we need to install the ionCube PHP loader to decrypt the PHP files. Dowload ionCube loaders.
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

#Extract it to /usr/lib/php/:
sudo tar -xzf ioncube_loaders_lin_x86-64.tar.gz -C /usr/lib/php

#If you use Nginx, edit the php.ini file:
sudo nano /etc/php/7.4/fpm/php.ini

#Add the following line right below the [PHP] line:
zend_extension=/usr/lib/php/ioncube/ioncube_loader_lin_7.4.so

#Save and close the file. We need to create a second PHP ini file:

sudo nano /etc/php/7.4/fpm/conf.d/10-ioncube.ini
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
memory_limit = 128M
max_execution_time = 300
output_buffering = Off
output_handler = ""
zlib.output_compression = Off
zlib.output_handler = ""
safe_mode = Off
register_globals = Off
magic_quotes_gpc = Off
upload_max_filesize = 20M
post_max_size = 20M
enable_dl = Off
disable_functions = ""
disable_classes = ""
session.save_handler = files
session.use_cookies = 1
session.use_only_cookies = 1
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_httponly = 1
date.timezone = "UTC"

#Save and close the file. Then restart Nginx and PHP7.4-FPM.
sudo systemctl restart nginx php7.4-fpm

#Now you should be able to visit the FileRun web-based install wizard at http://filerun.example.com, but before entering any information, let’s enable HTTPS.
#Step 5: Enable HTTPS
#To encrypt the HTTP traffic when you visit the FileRun web interface, we can enable HTTPS by installing a free TLS certificate issued from Let’s Encrypt. Run the following commands to install Let’s Encrypt client (certbot) on Ubuntu 20.04.

sudo apt update
sudo apt install certbot

#If you use Nginx, you also need to install the Certbot Nginx plugin.
sudo apt install python3-certbot-nginx

#Then run the following command to obtain and install TLS certificate.
sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d filerun.example.com

#Step 6: Finish the Installation in your Web Browser
#Go to https://filerun.example.com to launch the web-based install wizard. Then click Next button.
#In the next step, enter the MariaDB username, password, and database name you created in step 2.
#After clicking Next, the install wizard will automatically create a user account. Click Next to continue.
#On the next screen, you can log in with the superuser account. Upon first login, you need to create a home folder for the superuser account.
#You can create the home folder for superuser with the following command.
sudo mkdir /var/www/superuser
sudo chown www-data /var/www/superuser/ -R
#Then enter the folder path in FileRun web interface. And save the changes.
# Next, go to Security -> API to enable the API, so client apps can sync with the server.
#Install FileRun Desktop Sync Client:
#On desktop, FileRun uses Nextcloud client to sync with the server.  On Ubuntu desktop, you can install Nextcloud client with:
sudo apt install nextcloud-desktop
#For how to install client apps on other platforms, please check out the FileRun download page.
