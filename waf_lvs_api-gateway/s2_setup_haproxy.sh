# Phần 2. Các bước cài đặt cấu hình ubuntu 22.04 LTS server với haproxy 2.9 thêm sau khi phần 1. Cài iptables:
# Để cài đặt và cấu hình Ubuntu Server 22.04 LTS với ModSecurity WAF (Web Application Firewall) trên Nginx và sử dụng iptables và tc (traffic control) để
# quản lý giao thông mạng, bạn có thể tuân theo các bước sau:

#- Bổ sung haproxy 2.9 install vào đoạn code cài đặt lvs-iptables-iproute2.sh
#!/bin/bash
clear

#HAProxy: http://www.haproxy.org/
#The Reliable, High Performance TCP/HTTP Load Balancer
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

#- Soạn bổ sung code haproxy.cfg về bbb, ucs, mooc
#  Author: PhD. Le Toan Thang
# ================================================================================== #
#       H A P r o x y 2.9 - Big Blue Button (UCs)
# ================================================================================== #
# ref: https://docs.haproxy.org/2.9/configuration.html
# Ports need to be open: https://docs.bigbluebutton.org/administration/firewall-configuration/#:~:text=TCP%2FIP%20port%2022%20%28for%20SSH%29%20TCP%2FIP%20ports%2080%2F443,range%2016384%20-%2032768%20%28for%20FreeSWITCH%2FHTML5%20RTP%20streams%29
# Configure your firewall
# When BigBlueButton is protected behind a firewall, you need to configure the firewall to forward the following incoming connections to BigBlueButton:
# TCP/IP port 22 (for SSH)
# TCP/IP ports 80/443 (for HTTP/HTTPS)
# TCP.IP Port 5060, 5066 (for SIP/Audio/Media Streaming)
# UDP ports in the range 16384 - 32768 (for FreeSWITCH/HTML5 RTP streams) 
# Lưu ý: đây là các cổng được chỉ định mặc định và có thể được thay đổi từ màn hình cài đặt tương ứng trên Bảng điều khiển.
# cần cấu hình UFW linux với dải ipv4 được phép điều khiển SSH TCP/IP, và UDP port: 16384 - 32768
# ufw allow from any to 172.20.10.13/24 port 16384:32768 proto udp
# ufw allow from any to 172.20.10.13/24 port 22 proto udp

#frontend http-82
#        bind *:80
#        mode tcp
#        acl acl131 hdr_dom(host) -i ucs.io.vn
#        use_backend ucs-131 if acl131

#frontend https-82
#        bind *:443
#        mode tcp
#        tcp-request inspect-delay 10s
#        tcp-request content accept if { req_ssl_hello_type 1 }
#        acl acl131 req.ssl_sni -m end ucs.io.vn
#        use_backend ucss-131 if acl131

#backend ucs-131
#        mode tcp
#        server ucs-131 172.20.11.13:80
		
#backend ucss-131
#        mode tcp
#        server ucss-131 172.20.11.13:443
