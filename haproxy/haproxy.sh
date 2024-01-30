#!/bin/bash
clear

#HAProxy: http://www.haproxy.org/
#The Reliable, High Performance TCP/HTTP Load Balancer
# step 1. Update linux:
sudo apt update -y
sudo apt list --upgradable
sudo apt autoremove -y
sudo apt upgrade -y

#sudo apt install xrdp -y
#sudo systemctl enable xrdp
sudo apt install ufw -y
sudo apt install net-tools -y
sudo apt install gparted -y

# Cách cấu hình điều khiển HĐH Linux qua Web HTML 5
# https://thangletoan.wordpress.com/2022/05/22/cach-cau-hinh-dieu-khien-hdh-linux-qua-web-html-5/
. /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit -y

# After you already have Cockpit on your server, point your web browser to: https://ip-address-of-machine:9090
#sudo apt install ubuntu-desktop -y

# step 2. Setup HAPROXY: https://haproxy.debian.net/ >  https://haproxy.debian.net/#distribution=Ubuntu&release=focal&version=2.9 
sudo apt show haproxy
sudo apt install --no-install-recommends software-properties-common
sudo add-apt-repository ppa:vbernat/haproxy-2.9 -y 

sudo apt update -y
sudo apt install -y haproxy=2.9.\*
haproxy -v
sudo systemctl status haproxy
sudo systemctl enable haproxy
# Step 3. configure HAPROXY:
sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bk
#sudo nano /etc/haproxy/haproxy.cfg
#sudo reboot
