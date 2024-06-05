sudo apt update && sudo apt upgrade -y
#Step 1: Download WordPress
wget https://wordpress.org/latest.zip 
sudo apt install unzip -y
sudo mkdir -p /usr/share/nginx
sudo unzip latest.zip -d /usr/share/nginx/
sudo mv /usr/share/nginx/wordpress /usr/share/nginx/example.com
#Step 2: Create a Database and User for WordPress Site
sudo mariadb -u root
create database wordpress;
grant all privileges on wordpress.* to wpuser@localhost identified by 'your-password';
flush privileges;
exit;

#Step 3: Configure WordPress
cd /usr/share/nginx/example.com/

sudo cp wp-config-sample.php wp-config.php
sudo nano wp-config.php

/** The name of the database for WordPress */
define('DB_NAME', 'database_name_here');

/** MySQL database username */
define('DB_USER', 'username_here');

/** MySQL database password */
define('DB_PASSWORD', 'password_here');

$table_prefix = 'wp_';
$table_prefix = '9OzB3g_';


sudo chown www-data:www-data /usr/share/nginx/example.com/ -R

#Step 4: Create an Nginx Server Block for WordPress

sudo nano /etc/nginx/conf.d/example.com.conf

server {
  listen 80;
  listen [::]:80;
  server_name www.example.com example.com;
  root /usr/share/nginx/example.com/;
  index index.php index.html index.htm index.nginx-debian.html;

  location / {
    try_files $uri $uri/ /index.php;
  }

   location ~ ^/wp-json/ {
     rewrite ^/wp-json/(.*?)$ /?rest_route=/$1 last;
   }

  location ~* /wp-sitemap.*\.xml {
    try_files $uri $uri/ /index.php$is_args$args;
  }

  error_page 404 /404.html;
  error_page 500 502 503 504 /50x.html;

  client_max_body_size 20M;

  location = /50x.html {
    root /usr/share/nginx/html;
  }

  location ~ \.php$ {
    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    include snippets/fastcgi-php.conf;
    fastcgi_buffers 1024 4k;
    fastcgi_buffer_size 128k;

    # Add headers to serve security related headers
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Permitted-Cross-Domain-Policies none;
    add_header X-Frame-Options "SAMEORIGIN";
  }

  #enable gzip compression
  gzip on;
  gzip_vary on;
  gzip_min_length 1000;
  gzip_comp_level 5;
  gzip_types application/json text/css application/x-javascript application/javascript image/svg+xml;
  gzip_proxied any;

  # A long browser cache lifetime can speed up repeat visits to your page
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
END

sudo nginx -t
sudo systemctl reload nginx

sudo apt install -y php-imagick php7.4-fpm php7.4-mbstring php7.4-bcmath php7.4-xml php7.4-mysql php7.4-common php7.4-gd php7.4-json php7.4-cli php7.4-curl php7.4-zip
sudo systemctl reload php7.4-fpm nginx
#Increase Upload File Size Limit
#By default, files such as images, PDF files uploaded to the WordPress media library can not be larger than 2MB. 
#To increase the upload size limit, edit the PHP configuration file.

#sudo nano /etc/php/7.4/fpm/php.ini
#Find the following line (line 846).
#upload_max_filesize = 2M
#Change the value like below:
#upload_max_filesize = 20M
#Then find the following line (line 694).
#post_max_size = 8M
#Change the maximum size of POST data that PHP will accept.
#post_max_size = 20M
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/g' /etc/php/7.4/fpm/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 20M/g' /etc/php/7.4/fpm/php.ini
sudo systemctl restart php7.4-fpm

sudo nano /etc/nginx/conf.d/example.com.conf
client_max_body_size 2M;
client_max_body_size 20M;

sudo systemctl reload nginx


#Step 5: Enabling HTTPS
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d yourdomain.com,www.yourdomain.com

#Wher
#
#--nginx: Use the Nginx plugin.
#--agree-tos: Agree to terms of service.
#--redirect: Force HTTPS by 301 redirect.
#--hsts: Add the Strict-Transport-Security header to every HTTP response. Forcing the browser to always use TLS for the domain. Defends against SSL/TLS Stripping.
#--staple-ocsp: Enables OCSP Stapling. A valid OCSP response is stapled to the certificate that the server offers during TLS.
#--email: Email used for registration and recovery contact.
#-d flag is followed by a list of domain names, separated by comma. You can add up to 100 domain names.
#The certificate should now be obtained and automatically installed.
#Step 6: Finish the Installation with the Setup Wizard
#Create an admin account and click the Install WordPress button.
#We have already enabled redirecting HTTP to HTTPS, what’s left to do is redirect www to non-www, or vice versa. 
#It’s very easy. 
#Simply go to WordPress Dashboard > Settings > General and set your preferred version (www or non-www) in WordPress Address and Site Address. 
#Be sure to include the https:// prefix.

#ref: https://www.linuxbabe.com/ubuntu/install-wordpress-ubuntu-20-04-nginx-mariadb-php7-4-lemp
#ref 2: https://www.linuxbabe.com/nginx/what-are-spdy-and-http2-and-how-to-enable-them-on-nginx
