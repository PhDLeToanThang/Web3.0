# Phần 1. Các bước cài đặt cấu hình ubuntu 22.04 LTS server với modsecurity WAF nginx và iptables, tc
# Để cài đặt và cấu hình Ubuntu Server 22.04 LTS với ModSecurity WAF (Web Application Firewall) trên Nginx và sử dụng iptables và tc (traffic control) để
# quản lý giao thông mạng, bạn có thể tuân theo các bước sau:

#Bước 1: Cài đặt Ubuntu Server 22.04 LTS
# Tải xuống và cài đặt Ubuntu Server 22.04 LTS trên máy chủ của bạn.
# Chạy các bước cài đặt cơ bản như cấu hình mạng, tạo người dùng, vv.

#Bước 2: Cài đặt Nginx và ModSecurity
#1. Cài đặt Nginx trên Ubuntu Server
sudo apt update
sudo apt install nginx
#2. Cài đặt ModSecurity:
sudo apt install libnginx-mod-security

#Bước 3: Cấu hình Nginx và ModSecurity
#1. Kích hoạt module ModSecurity trong Nginx bằng cách thêm đoạn mã sau vào cấu hình Nginx (/etc/nginx/nginx.conf): 
# load_module modules/ngx_http_modsecurity_module.so;
#2. Cấu hình ModSecurity:
# Tạo file cấu hình ModSecurity: /etc/nginx/modsec/main.conf.
# Cấu hình ModSecurity để bảo vệ ứng dụng web của bạn.

#Bước 4: Cài đặt và Cấu hình iptables và tc
#1. Cài đặt iptables:
sudo apt install iptables

#2. Cấu hình iptables để quản lý lưu lượng mạng:
#Tạo các quy tắc cho iptables để kiểm soát luồng dữ liệu vào và ra.

#3. Cài đặt tc (traffic control):
sudo apt install iproute2

#4. Cấu hình tc để quản lý băng thông mạng:
#Sử dụng tc để quản lý và giám sát băng thông mạng cho các giao thức cụ thể hoặc phân loại lưu lượng.

#Bước 5: Khởi động lại Nginx và iptables
#1. Khởi động lại dịch vụ Nginx để áp dụng cấu hình mới:
sudo systemctl restart nginx
#2. Lưu cấu hình iptables:
sudo iptables-save > /etc/iptables/rules.v4

#Lưu ý:
#- Đảm bảo các cấu hình được kiểm tra kỹ lưỡng và thử nghiệm trước khi triển khai trên môi trường sản xuất.
#- Cập nhật hệ thống và các ứng dụng thường xuyên để bảo vệ khỏi các lỗ hổng bảo mật mới phát hiện.
#- Cấu hình iptables và tc cần được thích nghi với nhu cầu cụ thể của mạng và ứng dụng.
#########################################################################################################################
# Phần 2. Trong các bước cài nginx, modsecurity, iptables, iproute2 thì tôi cần gói cài có giao diện web làm monitor log và quản lý edit,
# delete các rules , roles của iptables, modesecurity, iproute2 ?
# Để quản lý và theo dõi log, cũng như quản lý và chỉnh sửa các quy tắc cho iptables, ModSecurity và iproute2 thông qua giao diện web, bạn có thể sử dụng các 
# công cụ quản lý bảo mật như Webmin hoặc Cockpit. Dưới đây là hướng dẫn cài đặt và sử dụng Webmin để quản lý các phần mềm này trên Ubuntu Linux:
# 1. Cài đặt Webmin trên Ubuntu Linux:
# 1.1.Cập nhật hệ thống:
sudo apt update
sudo apt upgrade
# 1.2.Cài đặt các gói cần thiết trước khi cài Webmin:
sudo apt install software-properties-common apt-transport-https wget
# 1.3.Thêm kho lưu trữ của Webmin vào hệ thống:
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
# 1.4. Cài đặt Webmin:
sudo apt update
sudo apt install webmin
# Truy cập vào giao diện Webmin thông qua trình duyệt web bằng cách truy cập vào địa chỉ: https://your_server_ip:10000
# 2. Sử dụng Webmin để quản lý iptables, ModSecurity và iproute2:
# 2.1. Quản lý iptables:
# Trong Webmin, bạn có thể vào mục "Networking" -> "Linux Firewall" để quản lý và chỉnh sửa các quy tắc iptables.
# Bạn có thể thêm, sửa đổi và xóa các quy tắc, xem log và cập nhật iptables thông qua giao diện web của Webmin.
# Quản lý ModSecurity:
# Cấu hình và quản lý ModSecurity có thể thực hiện thông qua giao diện Webmin bằng cách sử dụng các plugins và công cụ hữu ích có sẵn.
# Quản lý iproute2:
# Để quản lý iproute2 và quản lý các quy tắc mạng, bạn có thể sử dụng các plugin hoặc công cụ trong Webmin để thực hiện các thao tác cần thiết.
# Webmin cung cấp một giao diện thân thiện và dễ sử dụng cho việc quản lý hệ thống và bảo mật, giúp bạn theo dõi và quản lý các công cụ bảo mật như 
# iptables, ModSecurity và iproute2 một cách hiệu quả.

#########################################################################################################################
# Phần 3. Tạo Firewall NAT, Rules:
# Nếu bạn sử dụng một firewall khác thay vì UFW trên Ubuntu, quy trình mở cổng 80 và 443 cho HAProxy vẫn tương tự nhưng cú pháp và cách 
# thức cấu hình có thể khác nhau tùy thuộc vào firewall cụ thể đó. Dưới đây là một số ví dụ cho việc mở cổng 80 và 443 trên một số 
# firewall phổ biến khác:

# Để cấu hình iptables trên Ubuntu 22.04 LTS server như yêu cầu của bạn, cụ thể là chặn các kết nối từ internet qua WAN của nhà mạng 
# ISP và thiết lập các rules cho phép truy cập qua UDP port range và tới các server VPS cụ thể, bạn cần thực hiện các bước sau:
# 1. Chặn Tất Cả Các Kết Nối từ Internet qua WAN ISP Trừ Các Port Được Cho Phép:
# Chặn tất cả các kết nối đến máy chủ
iptables -P INPUT DROP

# 1. iptables:
# Cho phép các kết nối trên các port cụ thể (ví dụ: Port 80, 443)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Sau đó, hãy lưu lại cấu hình iptables:
sudo iptables-save > /etc/iptables/rules.v4

# Tôi dùng UFW trên ubuntu 22.04 LTS server sẽ cấu hình như thế nào để có thể cho phép truy cập từ internet vào qua giao thức UDP port # range từ 16378 tới
# 34579 và truy cập trực tiếp tới 1 server VPS có ipv4 LAN 192.168.1.25/24 và phần vẫn trên UFW cần quản lý giao 
# thức UDP port range từ 34800 đến 43000 và truy cập trực tiếp tới 1 server VPS khác có ipv4 LAN 192.168.10.37/24

# được viết liền trong một dòng và có thể hoạt động đúng nếu bạn muốn mở UDP port range từ 16378 đến 34579 và chỉ cho phép truy cập vào # server VPS có 
# IP LAN 192.168.1.25 qua các cổng đó.
# Nếu bạn muốn kết hợp việc chặn tất cả các kết nối đến ngoại trừ các kết nối đã được cho phép, bạn có thể thêm lệnh sudo ufw default 
# deny incoming ở trên cùng của các rules. Tuy nhiên, hãy nhớ rằng thứ tự của các rule trong UFW rất quan trọng. Các rule sẽ được áp 
# dụng theo thứ tự từ trên xuống dưới, vì vậy bạn cần đảm bảo rằng các rule được sắp xếp đúng để đảm bảo hệ thống hoạt động chính xác 
# và an toàn.
# Dưới đây là cách cấu hình UFW với các rule như bạn đã mô tả:

# 1. Cấu hình UFW cho UDP Port Range từ 16378 đến 34579 và Server 192.168.1.25/24:
# Mở UDP port range từ 16378 đến 34579
# Cho phép truy cập trực tiếp vào server VPS có IP LAN 192.168.1.25
# sudo ufw default deny incoming
# sudo ufw allow 16378:34579/udp from any to 192.168.1.25

# 2. Cho Phép Truy Cập từ Internet vào qua UDP Port Range và Server VPS Cụ Thể:
# Cấu hình UFW cho UDP Port Range từ 34800 đến 43000 và Server 192.168.10.37/24:
# Mở UDP port range từ 34800 đến 43000
# Cho phép truy cập trực tiếp vào server VPS có IP LAN 192.168.10.37
# Cho phép truy cập qua UDP port range từ 16378 tới 34579
iptables -A INPUT -p udp --dport 16378:34579 -j ACCEPT

# Cho phép truy cập tới server VPS có IP LAN 192.168.1.25
iptables -A INPUT -s 192.168.1.25 -j ACCEPT

# Quản lý UDP port range từ 34800 đến 43000 và truy cập tới server VPS có IP LAN 192.168.10.37
iptables -A INPUT -p udp --dport 34800:43000 -j ACCEPT
iptables -A INPUT -s 192.168.10.37 -j ACCEPT

# 3. Kích hoạt cấu hình và kiểm tra:
# Sau khi thực hiện các bước trên, bạn cần kích hoạt lại UFW để áp dụng cấu hình:
sudo ufw enable

#Để xác minh rằng quy tắc đã được áp dụng đúng, bạn có thể kiểm tra trạng thái của UFW bằng lệnh:
sudo ufw status

#Ngoài ra, bạn cũng có thể sử dụng các biến thể của lệnh status để xem chi tiết hơn về các rule cụ thể hoặc các thông số khác của UFW. #Dưới đây là một số lựa chọn phổ biến:
#sudo ufw status numbered: Hiển thị danh sách các rule theo số thứ tự.
#sudo ufw status verbose: Hiển thị thông tin chi tiết về trạng thái của UFW.
#sudo ufw status verbose numbered: Kết hợp giữa các tùy chọn verbose và numbered.

#Hãy chắc chắn rằng bạn đã hiểu rõ về việc thực hiện giới hạn băng thông và tinh chỉnh mạng trên hệ thống Linux trước khi áp dụng các #thay đổi này.
######################################################################
## Phần 4. Quản lý Traffic Sharping Security
# Để thực hiện traffic shaping, giới hạn băng thông hoặc quản lý số session tokens, bạn cần sử dụng công cụ tinh chỉnh mạng như tc
# (traffic control) trong Linux. tc cho phép bạn tinh chỉnh các thông số về băng thông, latency, packet loss, và nhiều tham số khác để
# kiểm soát traffic trên hệ thống của bạn.
# Dưới đây là một số hướng dẫn cơ bản về cách sử dụng tc để thực hiện traffic shaping và quản lý băng thông trên Linux:
# 1. Cài Đặt tc (Traffic Control):
# Đảm bảo rằng gói iproute2 đã được cài đặt trên hệ thống của bạn:
# sudo apt update
# sudo apt install iproute2

# 2. Thực Hiện Traffic Shaping với tc:
# Dưới đây là một ví dụ về cách giới hạn băng thông cho một interface cụ thể (ví dụ: eth0) trong Linux bằng tc:
sudo tc qdisc add dev eth0 root tbf rate 10mbit burst 32kbit latency 40ms

# Trong ví dụ trên, băng thông được giới hạn ở 10mbit.
# 3. Quản Lý Số Session Tokens:
# Để quản lý số session tokens, bạn có thể sử dụng các công cụ như iptables để thiết lập các rules cho việc quản lý kết nối. 
# Ví dụ, bạn có thể sử dụng iptables để giới hạn số lượng kết nối đến một cổng cụ thể.
#
# Cho ví dụ cụ thể về giới hạn băng thông 5Mbps cho TCP trên LAN 192.168.1.0/24?
# Để giới hạn băng thông cho giao thức TCP trên mạng LAN với địa chỉ IP 192.168.1.0/24 thành 5Mbps, bạn có thể sử dụng tc để thực hiện
# điều này trên Linux. Dưới đây là cách thực hiện:
# 
# 4. Sử Dụng tc để Giới Hạn Băng Thông cho TCP:
# Đầu tiên, bạn cần tạo một class để giới hạn băng thông cho giao thức TCP. Dưới đây là ví dụ cụ thể với giới hạn băng thông 10Mbps:
# sudo tc qdisc add dev eth0 root handle 1: htb default 12
sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 10mbit
sudo tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst 192.168.1.0/24 match ip protocol 6 0xff flowid 1:1
# eth0: là interface mạng cần áp dụng giới hạn băng thông.
# rate 10mbit: giới hạn băng thông thành 10Mbps.
# match ip dst 192.168.1.0/24: áp dụng giới hạn cho mạng LAN có địa chỉ IP 192.168.1.0/24.
# match ip protocol 6 0xff: áp dụng cho giao thức TCP (6).
# Với các lệnh trên, bạn đã áp dụng giới hạn băng thông 10Mbps cho giao thức TCP trên mạng LAN có địa chỉ IP 192.168.1.0/24 thông qua #interface mạng eth0.
#Lưu ý: Hãy thay thế eth0 bằng tên interface mạng thực tế trong hệ thống của bạn và đảm bảo rằng bạn đang thực hiện các thay đổi này #trên hệ thống mạng phù
# hợp. Sử dụng lệnh tc qdisc show dev eth0 để kiểm tra xem rule đã được áp dụng thành công hay chưa.
# Hãy chắc chắn rằng bạn đã hiểu rõ về việc thực hiện giới hạn băng thông và tinh chỉnh mạng trên hệ thống Linux trước khi áp dụng các #thay đổi này.