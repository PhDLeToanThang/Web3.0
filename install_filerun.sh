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
#!-- sudo nano /etc/apache2/sites-available/filerun.conf
sudo nano /etc/nginx/conf.d/filerun.conf
