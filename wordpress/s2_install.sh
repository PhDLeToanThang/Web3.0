######################################################################################
#    What's new Wordpress 6.7.2 
#		here is a short list of main changes done in this version: https://wordpress.org/latest.zip 
# This iteration of Wordpress 6.7.2 contains 
# Note that Wordpress 6.7.2 runs on Ubuntu  (24.04 LTS).
######################################################################################
#!/bin/bash -e
clear
cd ~

############### Tham số cần thay đổi ở đây ###################
echo "FQDN: e.g: demo.company.vn"   # Đổi địa chỉ web thứ nhất Website Master for Resource code - để tạo cùng 1 Source code duy nhất 
read -e FQDN

echo "Email Address of Admin CA SSL/TLS"   # Địa chỉ email của nhà quản trị SSL/TLS cho HTTPS
read -e emailssl

echo "dbname: e.g: demodata"   # Tên DBNane
read -e dbname

echo "dbuser: e.g: userdata"   # Tên User access DB lmsatcuser
read -e dbuser

echo "Database Password: e.g: P@$$w0rd-1.22"
read -s dbpass

echo "phpmyadmin folder name: e.g: phpmyadmin"   # Đổi tên thư mục phpmyadmin khi add link symbol vào Website 
read -e phpmyadmin

echo "Moodle Folder Data: e.g: moodledata"   # Tên Thư mục chưa Data vs Cache
read -e FOLDERDATA

echo "dbtype name: e.g: mariadb"   # Tên kiểu Database
read -e dbtype

echo "dbhost name: e.g: localhost"   # Tên Db host connector
read -e dbhost

echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
  exit
else
sudo apt update && sudo apt upgrade -y
sudo apt-get install nginx -y
sudo systemctl stop nginx.service
sudo systemctl start nginx.service
sudo systemctl enable nginx.service

#Step 1. Install MariaDB/MySQL
#Run the following commands to install MariaDB database for Moode. You may also use MySQL instead.
sudo apt-get install mariadb-server mariadb-client -y

#Like NGINX, we will run the following commands to enable MariaDB to autostart during reboot, and also start now.
sudo systemctl stop mysql.service 
sudo systemctl start mysql.service 
sudo systemctl enable mysql.service

#Run the following command to secure MariaDB installation.
#password mysql mariadb , i'm fixed: M@tKh@uS3cr3t  --> you must changit. 

sudo mysql_secure_installation  <<EOF
n
M@tKh@uS3cr3t
M@tKh@uS3cr3t
y
n
y
y
EOF
#You will see the following prompts asking to allow/disallow different type of logins. Enter Y as shown.
# Enter current password for root (enter for none): Just press the Enter
# Set root password? [Y/n]: Y
# New password: Enter password
# Re-enter new password: Repeat password
# Remove anonymous users? [Y/n]: Y
# Disallow root login remotely? [Y/n]: N
# Remove test database and access to it? [Y/n]:  Y
# Reload privilege tables now? [Y/n]:  Y
# After you enter response for these questions, your MariaDB installation will be secured.

#Step 2. Install PHP-FPM & Related modules
sudo apt install software-properties-common -y
sudo -S add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install -y php8.3-fpm php8.3-common php8.3-mbstring php8.3-xmlrpc php8.3-soap php8.3-gd php8.3-xml php8.3-intl php8.3-mysql php8.3-cli php8.3-mcrypt php8.3-ldap php8.3-zip php8.3-curl php-imagick php8.3-bcmath

#Open PHP-FPM config file.
#sudo nano /etc/php/8.3/fpm/php.ini
#Add/Update the values as shown. You may change it as per your requirement.
#Increase Upload File Size Limit
#By default, files such as images, PDF files uploaded to the WordPress media library can not be larger than 2MB. 
#To increase the upload size limit, edit the PHP configuration file.

cat > /etc/php/8.3/fpm/php.ini <<END
file_uploads = On
allow_url_fopen = On
memory_limit = 1200M
upload_max_filesize = 512M
max_execution_time = 360
cgi.fix_pathinfo = 0
date.timezone = asia/ho_chi_minh
max_input_time = 60
max_input_nesting_level = 64
max_input_vars = 5000
post_max_size = 512M
END

systemctl restart php8.3-fpm.service

# install tool mysql-workbench-community from Tonin Bolzan (tonybolzan)
sudo snap install mysql-workbench-community

#Step 3: Download WordPress
wget https://wordpress.org/latest.zip 
sudo apt install unzip -y
sudo mkdir -p /usr/share/nginx
sudo unzip latest.zip -d /usr/share/nginx/
sudo mv /usr/share/nginx/wordpress /usr/share/nginx/$FQDN

#Step 4: Create a Database and User for WordPress Site
mysql -uroot -prootpassword -e "DROP DATABASE IF EXISTS ${dbname};"
mysql -uroot -prootpassword -e "CREATE DATABASE IF NOT EXISTS ${dbname} CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -uroot -prootpassword -e "CREATE USER IF NOT EXISTS '${dbuser}'@'${dbhost}' IDENTIFIED BY \"${dbpass}\";"
mysql -uroot -prootpassword -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'${dbhost}';"
mysql -uroot -prootpassword -e "FLUSH PRIVILEGES;"
mysql -uroot -prootpassword -e "SHOW DATABASES;"
mysql -uroot -prootpassword -e "EXIT;"

#Step 5. Next, edit the MariaDB default configuration file and define the innodb_file_format:
#nano /etc/mysql/mariadb.conf.d/50-server.cnf
#Add the following lines inside the [mysqld] section: 
cat > /etc/mysql/mariadb.conf.d/50-server.cnf <<END
[mysqld]
innodb_file_format = Barracuda
innodb_file_per_table = 1
innodb_large_prefix = ON
max_allowed_packet=128M
END

#Save the file then restart the MariaDB service to apply the changes.
systemctl restart mariadb

#Step 6: Configure WordPress
cd /usr/share/nginx/$FQDN

# sudo nano wp-config.php
cat > /usr/share/nginx/$FQDN/wp-config.php <<END
END

echo '<?php'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'DB_NAME', '"$dbname"' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'DB_USER', '"$dbuser"' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'DB_PASSWORD', '"$dbpass"' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'DB_HOST', 'localhost' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'DB_CHARSET', 'utf8' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'DB_COLLATE', '' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'AUTH_KEY',         'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'LOGGED_IN_KEY',    'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'NONCE_KEY',        'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'AUTH_SALT',        'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'LOGGED_IN_SALT',   'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'NONCE_SALT',       'put your unique phrase here' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo '$table_prefix = 'wp_';'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'WP_DEBUG', false );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'if ( ! defined( 'ABSPATH' ) ) {'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'define( 'ABSPATH', __DIR__ . '/' );'  >> /usr/share/nginx/$FQDN/wp-config.php
echo '}'  >> /usr/share/nginx/$FQDN/wp-config.php
echo 'require_once ABSPATH . 'wp-settings.php';'  >> /usr/share/nginx/$FQDN/wp-config.php


sudo chown www-data:www-data /usr/share/nginx/$FQDN/ -R

#Step 7: Create an Nginx Server Block for WordPress

#sudo nano /etc/nginx/conf.d/$FQDN.conf
cat > /etc/nginx/conf.d/$FQDN.conf <<END
END

echo 'server {' >> /etc/nginx/conf.d/$FQDN.conf
echo 'listen 80;' >> /etc/nginx/conf.d/$FQDN.conf
echo '   server_name '$FQDN';' >> /etc/nginx/conf.d/$FQDN.conf
echo '   root /usr/share/nginx/'$FQDN'/;' >> /etc/nginx/conf.d/$FQDN.conf
echo '   index index.php;' >> /etc/nginx/conf.d/$FQDN.conf
echo '   server_tokens off;' >> /etc/nginx/conf.d/$FQDN.conf
echo '   access_log /var/log/nginx/wordpress_access.log;' >> /etc/nginx/conf.d/$FQDN.conf
echo '   error_log /var/log/nginx/wordpress_error.log;' >> /etc/nginx/conf.d/$FQDN.conf
echo '   client_max_body_size 64M;' >> /etc/nginx/conf.d/$FQDN.conf
echo 'location / {' >> /etc/nginx/conf.d/$FQDN.conf
echo '   try_files $uri $uri/ /index.php?$args;' >> /etc/nginx/conf.d/$FQDN.conf
echo '}' >> /etc/nginx/conf.d/$FQDN.conf
echo '   location ~ \.php$ {' >> /etc/nginx/conf.d/$FQDN.conf
echo '      fastcgi_pass  unix:/run/php/php8.3-fpm.sock;' >> /etc/nginx/conf.d/$FQDN.conf
echo '      fastcgi_index index.php;' >> /etc/nginx/conf.d/$FQDN.conf
echo '      include fastcgi_params;' >> /etc/nginx/conf.d/$FQDN.conf
echo '      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    	include snippets/fastcgi-php.conf;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    	fastcgi_buffers 1024 4k;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    	fastcgi_buffer_size 128k;' >> /etc/nginx/conf.d/$FQDN.conf
echo '      include /etc/nginx/fastcgi.conf;' >> /etc/nginx/conf.d/$FQDN.conf
echo '    }' >> /etc/nginx/conf.d/$FQDN.conf
echo '}' >> /etc/nginx/conf.d/$FQDN.conf

server {
listen 80;
   server_name hanoidata.com.vn;
   root /usr/share/nginx/hanoidata.com.vn/;
   index index.php;
   server_tokens off;
   access_log /var/log/nginx/wordpress_access.log;
   error_log /var/log/nginx/wordpress_error.log;
   client_max_body_size 64M;
location / {
   try_files $uri $uri/ /index.php?$args;
}
   location ~ \.php$ {
      fastcgi_pass  unix:/run/php/php8.3-fpm.sock;
      fastcgi_index index.php;
      include fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    	include snippets/fastcgi-php.conf;
    	fastcgi_buffers 1024 4k;
    	fastcgi_buffer_size 128k;
      include /etc/nginx/fastcgi.conf;
    }
}

#echo 'server {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  listen 80;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  listen [::]:80;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  server_name '$FQDN';' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  root /usr/share/nginx/'$FQDN'/;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  index index.php index.html index.htm;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  location / {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    try_files $uri $uri/ /index.php;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '   location ~ ^/wp-json/ {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '     rewrite ^/wp-json/(.*?)$ /?rest_route=/$1 last;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '   }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  location ~* /wp-sitemap.*\.xml {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    try_files $uri $uri/ /index.php$is_args$args;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  error_page 404 /404.html;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  error_page 500 502 503 504 /50x.html;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  client_max_body_size 20M;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  location = /50x.html {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    root /usr/share/nginx/html;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  location ~ \.php\$ {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    fastcgi_pass unix:/run/php/php8.3-fpm.sock;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    include fastcgi_params;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    include snippets/fastcgi-php.conf;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    fastcgi_buffers 1024 4k;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    fastcgi_buffer_size 128k;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    # Add headers to serve security related headers' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    add_header X-Content-Type-Options nosniff;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    add_header X-XSS-Protection "1; mode=block";' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    add_header X-Permitted-Cross-Domain-Policies none;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '    add_header X-Frame-Options "SAMEORIGIN";' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  #enable gzip compression' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  gzip on;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  gzip_vary on;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  gzip_min_length 1000;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  gzip_comp_level 5;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  gzip_types application/json text/css application/x-javascript application/javascript image/svg+xml;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  gzip_proxied any;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  # A long browser cache lifetime can speed up repeat visits to your page' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  location ~* \.(jpg|jpeg|gif|png|webp|svg|woff|woff2|ttf|css|js|ico|xml)$ {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '       access_log        off;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '       log_not_found     off;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '       expires           360d;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  # disable access to hidden files' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  location ~ /\.ht {' >> /etc/nginx/conf.d/$FQDN.conf
#echo '      access_log off;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '      log_not_found off;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '      deny all;' >> /etc/nginx/conf.d/$FQDN.conf
#echo '  }' >> /etc/nginx/conf.d/$FQDN.conf
#echo '}' >> /etc/nginx/conf.d/$FQDN.conf

sudo nginx -t
sudo systemctl reload nginx
sudo systemctl reload php8.3-fpm nginx
sudo systemctl reload nginx

#Step 8. Install Certbot:
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email $emailssl -n -d $FQDN

#Wher
#sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d yourdomain.com,www.yourdomain.com
#--nginx: Use the Nginx plugin.
#--agree-tos: Agree to terms of service.
#--redirect: Force HTTPS by 301 redirect.
#--hsts: Add the Strict-Transport-Security header to every HTTP response. Forcing the browser to always use TLS for the domain. Defends against SSL/TLS Stripping.
#--staple-ocsp: Enables OCSP Stapling. A valid OCSP response is stapled to the certificate that the server offers during TLS.
#--email: Email used for registration and recovery contact.
#-d flag is followed by a list of domain names, separated by comma. You can add up to 100 domain names.
#The certificate should now be obtained and automatically installed.
# You should test your configuration at:
# https://www.ssllabs.com/ssltest/analyze.html?d=$FQDN
#/etc/letsencrypt/live/$FQDN/fullchain.pem
#   Your key file has been saved at:
#   /etc/letsencrypt/live/$FQDN/privkey.pem
#   Your cert will expire on yyyy-mm-dd. To obtain a new or tweaked
#   version of this certificate in the future, simply run certbot again
#   with the certonly option. To non-interactively renew *all* of
#   your certificates, run certbot renew
fi
