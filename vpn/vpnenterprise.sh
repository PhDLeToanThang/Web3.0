#!/bin/bash

#Step 1: Update your system
#First update and upgrade your system before beginning installation by running the below commands:
sudo apt-get update -y
sudo apt-get -y upgrade

# Cấu hình Remote Desktop Access RDP 3389 tới máy chủ vật lý hoặc máy ảo Ubuntu 20.x/22.x LTS server
# https://thangletoan.wordpress.com/2023/10/31/cau-hinh-remote-desktop-access-rdp-3389-toi-may-chu-vat-ly-hoac-may-ao-ubuntu-20-x-22-x-lts-server/
sudo apt install xrdp -y
sudo apt install xserver-xorg-core -y
sudo apt install xserver-xorg-input-all -y
sudo apt install xorgxrdp -y

#You also need to grant access to the /etc/ssl/private/ssl-cert-snakeoil.key file for xrdp user. 
#It is available to members of the ssl-cert group by default.
# add xrdp into ssl-cert group
sudo adduser xrdp ssl-cert

# start xrdp service
sudo systemctl start xrdp

# check xrdp state
systemctl is-active xrdp 

#active
sudo systemctl enable xrdp # start xrdp on system start

#Firewall configuration:   
sudo ufw allow 3389

# (dải ipv4 cho guacamole Server tới VM cần điều khiển) 
sudo ufw allow from 192.168.100.0/24 to any port 3389   

#Reboot system:  (không cần thiết)
#sudo reboot

sudo apt install ufw -y
sudo apt install net-tools -y
sudo apt install gparted -y
sudo apt install ifupdown -y

# After you already have Cockpit on your server, point your web browser to: https://ip-address-of-machine:9090
sudo apt install ubuntu-desktop -y
sudo apt remove libreoffice-* -y

sudo apt-get install openvswitch-switch -y
sudo systemctl start openvswitch-switch
systemctl restart systemd-networkd

#Firewall configuration:
sudo ufw allow 3389
sudo ufw allow ssh

#sudo ufw enable 
sudo reboot

apt-get install curl gnupg2 wget unzip -y

#Step 2: Add Pritunl and MongoDB repositories and public keys
#Next, add Pritunl repository to your Ubuntu 20.04 using the below command.
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

#Pritunl VPN is build from MongoDB. We will go ahead to also add Mongodb repository using the command below:
echo "deb http://repo.pritunl.com/stable/apt focal main" | tee /etc/apt/sources.list.d/pritunl.list
apt-get update -y
apt-get install pritunl -y

#Now add public keys for MongoDB and Pritunl repositories.
systemctl start pritunl
systemctl enable pritunl
systemctl status pritunl

ss -antpl | grep pritunl

#Step 3: Install Pritunl and MongoDB
#Install Pritunl and MongoDB on Ubuntu 20.04 with the below commands:
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

apt-get update -y
apt-get install mongodb-server -y

#Now start and enable Pritunl and MongoDB as below:
systemctl start mongodb
systemctl enable mongodb
systemctl status mongodb

#Kiểm tra port 27017
ss -antpl | grep 27017

#Step 4: Configure Pritunl on Ubuntu 20.04
#At this point, Pritunl VPN is installed and running. Access it from the browser using your server IP to configure it. http://<your_server_ip>. You should get a page as below:

#Generate setup-key by running the command below:
sudo pritunl setup-key
#c31b15da3b534819b7f2fb7da1892062

#Once you enter the setup-key and mongodb url, it will prompt you for username and password.

#The default username and password are obtained with the below command:
sudo pritunl default-password
#[undefined][2020-11-15 18:01:55,033][INFO] Getting default administrator password
#Administrator default password:
#username: "pritunl"
#password: "Abcdef@1234567890"

#When you login with the provided credentials, you get a page as below:
#Set your new password and save and you should be taken to a page to configure organizations, users and servers.
#To add users, click on ‘Users’. This takes you to a window to first add organization.
#Click on ‘Add organization’ then provide it a name then click ‘Add’.

#Your organization should now be added as below
#Click on ‘Add user’ to create a user. Provide the required details and click ‘Add’.
#If you want to add many users at once, click on ‘Bulk Add user’.
#Let’s now create a Vpn server. Click on ‘servers’ then ‘Add server’
#Provide server particulars and click ‘Add’. You should see that the server has successfully been added as below:
#Remember to attach the server to an organization by clicking on ‘Attach organization’ and choosing your organization.

#Step 5: Configure Pritunl Client on Ubuntu 20.04
#We are now going configure Pritunl VPN client to connect to Pritunl server. For Ubuntu 20.04, run the below commands to install Pritunl VPN client.
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt focal main
EOF
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get install pritunl-client-electron
