# Phần 1. Các bước cài đặt cấu hình ubuntu 22.04 LTS server với nginx và iptables, tc
# Để cài đặt và cấu hình Ubuntu Server 22.04 LTS với ModSecurity WAF (Web Application Firewall) trên Nginx và sử dụng iptables và tc (traffic control) để
# quản lý giao thông mạng, bạn có thể tuân theo các bước sau:

#Bước 1: Cài đặt Ubuntu Server 22.04 LTS
# Tải xuống và cài đặt Ubuntu Server 22.04 LTS trên máy chủ của bạn.
# Chạy các bước cài đặt cơ bản như cấu hình mạng, tạo người dùng, vv.

#Bước 2: Cài đặt Nginx và iptables
#1. Cài đặt Nginx trên Ubuntu Server
sudo apt update -y
sudo apt list --upgradable 
sudo apt autoremove -y 
sudo apt update -y

#Bước 3: Cài đặt và Cấu hình iptables và tc
#1. Cài đặt iptables 1.8.10-3ubuntu2
sudo apt install iptables

#2. Cấu hình iptables để quản lý lưu lượng mạng:
#Tạo các quy tắc cho iptables để kiểm soát luồng dữ liệu vào và ra.

#3. Cài đặt tc (traffic control) v:6.1.0-1ubuntu6
sudo apt install iproute2

#4. Cấu hình tc để quản lý băng thông mạng:
#Sử dụng tc để quản lý và giám sát băng thông mạng cho các giao thức cụ thể hoặc phân loại lưu lượng.

#Bước 4: Kịch bản cấu hình cho iptables:
#Tôi muốn dùng iptables trên ubuntu 24.04 LTS server có 2 card mạng 1 WAN name: ens192 ipv4 124.158.6.84/26 và 1 LAN name: ens224 ipv4 làm Gateway LAN
#192.168.100.2 sẽ cấu hình như thế nào để có thể cấm truy cập tất các kết nối từ internet WAN vào các máy chủ; chỉ cho phép truy cập từ internet WAN vào qua
# giao thức UDP port range từ 16378 tới 32768 truy cập trực tiếp tới 1 server VPS có ipv4 LAN 192.168.100.14/24; đồng thời cũng có rules khác như: cho phép
# truy cập internet vào qua giao thức UDP port range từ 32769 - 34769 truy cập trực tiếp tới 1 server VPS có ipv4 192.168.100.15/24; tiếp theo rule khác cho
# phép kết nối port forward tới máy chủ haproxy verison 2.9 cho phép cấu hình proxy quản lý các TCP mode (haproxy service cài đặt cũng trên chính máy chủ
# ubuntu 24.04 LTS này) với cấu hình frontend, backend để quản lý các giao thức TCP port 80,443, 8080, 8443, 9443,9090 trỏ tới máy chủ Web hosting UCS
# 192.168.100.14/24 và 192.168.100.15/24 hoặc 192.168.100.30/24. Tiếp theo các máy chủ Web hosting TCP/UDP mode nói trên có cấu hình Default gateway output
# trỏ về LAN gateway ipv4 của chính card LAN ipv4 192.168.100.2 (ip của iptables ubuntu 24.04 và haproxy)

# Để cấu hình iptables trên Ubuntu 24.04 LTS server với 2 card mạng (ens192 cho WAN và ens224 cho LAN), để đáp ứng yêu cầu của bạn, bạn cần thực hiện các bước sau:

### 1. Cấm truy cập tất cả các kết nối từ internet WAN vào các máy chủ

#sudo iptables -A INPUT -i ens192 -j DROP

# Trong đó `ens192` là giao diện kết nối với Internet (WAN).

### 2. Cho phép truy cập từ internet WAN qua giao thức UDP port range từ 16378 đến 32768 tới server VPS có địa chỉ IP LAN 192.168.100.14

sudo iptables -A INPUT -i ens192 -p udp --dport 16378:32768 -d 192.168.100.14 -j ACCEPT

### 3. Cho phép truy cập từ internet WAN qua giao thức UDP port range từ 32769 đến 34769 tới server VPS có địa chỉ IP LAN 192.168.100.15

sudo iptables -A INPUT -i ens192 -p udp --dport 32769:34769 -d 192.168.100.15 -j ACCEPT

### 4. Cấu hình Port Forwarding cho máy chủ HAProxy

sudo iptables -A PREROUTING -t nat -i ens192 -p tcp --dport 80 -j DNAT --to-destination 192.168.100.2:80
sudo iptables -A PREROUTING -t nat -i ens192 -p tcp --dport 443 -j DNAT --to-destination 192.168.100.2:443
sudo iptables -A PREROUTING -t nat -i ens192 -p tcp --dport 8080 -j DNAT --to-destination 192.168.100.2:8080
sudo iptables -A PREROUTING -t nat -i ens192 -p tcp --dport 8443 -j DNAT --to-destination 192.168.100.2:8443
sudo iptables -A PREROUTING -t nat -i ens192 -p tcp --dport 9443 -j DNAT --to-destination 192.168.100.2:9443
sudo iptables -A PREROUTING -t nat -i ens192 -p tcp --dport 9090 -j DNAT --to-destination 192.168.100.2:9090

### 5. Lưu và áp dụng cấu hình iptables

#Sau khi thêm các quy tắc, bạn cần lưu cấu hình và áp dụng để chúng có hiệu lực:

sudo iptables-save > /etc/iptables/rules.v4

### Lưu ý:

#- Đảm bảo rằng các quy tắc được thêm đúng cách và theo đúng cú pháp.
#- Luôn kiểm tra kỹ lưỡng trước khi cấm hoặc cho phép kết nối để tránh ảnh hưởng đến hoạt động của hệ thống.
# Với các bước trên, bạn đã cấu hình iptables để thực hiện yêu cầu của mình trên Ubuntu 24.04 LTS server với 2 card mạng ens192 (WAN) và ens224 (LAN). Hãy
# chắc chắn kiểm tra kỹ lưỡng trước khi triển khai để đảm bảo tính đúng đắn của cấu hình.