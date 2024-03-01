# HAProxy 2.9
* LOAD_BALANCER USING HAPROXY ON NGINX WEB_SERVER
* Firewall Gateway Layer 4 base và Layer 7 for Application Specialist (Minio Cluster Enterprise Licenses, Office Web Oneline - OOS, PowerBI - PBI report servers, Teramind Audit, Wifi Cloud 5G, IoT Gateway Hub vs Sensors...)
* SOLUTION GETTING THE CONFIGURATION ON YOUR NGINX WEB_SERVER
#HAProxy: http://www.haproxy.org/
#The Reliable, High Performance TCP/HTTP Load Balancer
----
* Bước 1. Cập nhật linux:
<!-- sudo apt update -y
sudo apt list --upgradable
sudo apt autoremove -y
sudo apt upgrade -y
sudo apt install xrdp -y
sudo systemctl enable xrdp
sudo apt install ufw -y
sudo apt install net-tools -y
sudo apt install gparted -y -->
<!-- . /etc/os-release
sudo apt install -t ${VERSION_CODENAME}-backports cockpit -y -->
#After you already have Cockpit on your server, point your web browser to: https://ip-address-of-machine:9090
<!-- sudo apt install ubuntu-desktop -y -->
-----
* Bước 2. cài HAPROXY 2.9:
<!-- sudo apt show haproxy
sudo add-apt-repository ppa:vbernat/haproxy-2.9 -y
sudo apt update -y
sudo apt install -y haproxy=2.9.\*
haproxy -v
sudo systemctl status haproxy
sudo systemctl enable haproxy
 ----
* Bước 3. Cấu hình HAPROXY:
<!-- sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bk
sudo nano /etc/haproxy/haproxy.cfg -->

* Lưu ý: Các mô hình , cấu hình cân bằng tải tuỳ theo từng dạng mô hình dịch vụ Web services, kiểu máy chủ đơn lẻ, cụm 2 máy, cluster node... 
 * Web Hosting All in One "Standalone.
 * Email Exchange DAG là khác
 * Minio Node-Single
 * Minio Distribute Node Cluster
- Tôi có viết và cập nhật các sample_[tên các lại dịch vụ công nghệ]_haproxy.cfg
  để các bạn có thể tham khảo, copy/paste, thêm vào và thay đổi các tham số có /etc/haproxy/haproxy.cfg 
-----
* Bước 4. Kiểm tra tình trạng HAProxy Load Balancing:
Ngay sau khi sửa cấu hình Haproxy.cfg , bạn không nên restart lại haproxy , vì việc sửa cấu hình chỉ được kiểm tra cú pháp, còn chưa được sửa
về logic, hoặc chưa đúng tham số sẽ có thể gây lỗi không start lên dịch vụ haproxy, gây lỗi cho các dịch vụ truy cập vào.
-  Nên dùng lệnh kiểm tra cú pháp trước:  haproxy -c -f /etc/haproxy/haproxy.cfg    để debug cú pháp vừa sửa.
-  Nếu thấy lỗi thì dùng lệnh: sudo nano /etc/haproxy/haproxy.cfg   quay lại để sửa
-  Nếu sửa xong lỗi thì dùng lệnh: haproxy -c -f /etc/haproxy/haproxy.cfg
-  Sau khi đảm bảo không còn lỗi cú pháp thì dùng lệnh tiếp theo kiểm tra hệ thống: journalctl -xe
-  Sau khi xem kỹ các log thông báo không có lỗi gì về cấu hình haproxy.cfg thì chúng ta mới dùng lệnh: sudo service haproxy restart để khởi động.
-  Cuối cùng dùng lệnh: systemctl status haproxy.service để kiểm tra tình trạng haproxy service có khởi động lệnh hoặc bị lỗi gì không .

# 📚 Author 🖋️ Lê Toàn Thắng
