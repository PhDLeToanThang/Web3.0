#!/bin/bash
#
# Script cài đặt Pritunl VPN Server trên Ubuntu 24.04 LTS (Noble)
# Tác giả gốc: PhDLeToanThang
# Cập nhật: 2026 - Hỗ trợ Ubuntu 24.04 LTS
#
# GitHub: https://github.com/PhDLeToanThang/Web3.0/blob/main/vpn/vpnenterprise.sh
#
# Thay đổi chính so với bản gốc (Ubuntu 20.04/22.04):
#   - Dùng gpg --dearmor thay vì apt-key (đã deprecated)
#   - MongoDB 8.0 (thay vì 4.4)
#   - OpenVPN repository riêng cho Ubuntu 24.04
#   - WireGuard packages chuẩn
#   - Không cài ubuntu-desktop (tùy chọn, có thể bỏ comment)
#   - Sửa repository codename từ focal -> noble
#

set -e

# ================================================================
# Hàm kiểm tra lỗi
# ================================================================
check_error() {
    if [ $? -ne 0 ]; then
        echo "[ERROR] $1"
        exit 1
    fi
}

echo "========================================"
echo " Bắt đầu cài đặt Pritunl VPN Server"
echo " Hỗ trợ: Ubuntu 24.04 LTS (Noble)"
echo "========================================"

# ================================================================
# Bước 1: Cập nhật hệ thống
# ================================================================
echo "[1/8] Cập nhật hệ thống..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl gnupg2 wget unzip software-properties-common

# ================================================================
# Bước 2: Cài đặt Remote Desktop (RDP) - xrdp
# ================================================================
echo "[2/8] Cấu hình Remote Desktop (RDP) cổng 3389..."
sudo apt install -y xrdp xserver-xorg-core xserver-xorg-input-all xorgxrdp
sudo adduser xrdp ssl-cert
sudo systemctl start xrdp
sudo systemctl enable xrdp

# ================================================================
# Bước 3: Cấu hình Firewall (UFW)
# ================================================================
echo "[3/8] Cấu hình UFW Firewall..."
sudo apt install -y ufw
sudo ufw allow 3389
sudo ufw allow ssh
sudo ufw allow from 192.168.100.0/24 to any port 3389
echo "Firewall rules configured (not enabled yet - enable manually with 'sudo ufw enable')"

# ================================================================
# Bước 4: Cài đặt các gói hỗ trợ
# ================================================================
echo "[4/8] Cài đặt gói hỗ trợ..."
sudo apt install -y net-tools gparted ifupdown openvswitch-switch
sudo systemctl start openvswitch-switch || true

# ================================================================
# Bước 5: Thêm repository và GPG keys
# ================================================================
echo "[5/8] Thêm repository và GPG keys..."
sudo apt install -y gnupg

# MongoDB 8.0 GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc \
    | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor --yes

# OpenVPN repository GPG key
curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg \
    | sudo gpg -o /usr/share/keyrings/openvpn-repo.gpg --dearmor --yes

# Pritunl GPG key
curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc \
    | sudo gpg -o /usr/share/keyrings/pritunl.gpg --dearmor --yes

# Thêm repository MongoDB 8.0 cho Ubuntu 24.04 (noble)
sudo tee /etc/apt/sources.list.d/mongodb-org.list << EOF
deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse
EOF

# Thêm repository OpenVPN cho Ubuntu 24.04 (noble)
sudo tee /etc/apt/sources.list.d/openvpn.list << EOF
deb [ signed-by=/usr/share/keyrings/openvpn-repo.gpg ] https://build.openvpn.net/debian/openvpn/stable noble main
EOF

# Thêm repository Pritunl cho Ubuntu 24.04 (noble)
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb [ signed-by=/usr/share/keyrings/pritunl.gpg ] https://repo.pritunl.com/stable/apt noble main
EOF

# ================================================================
# Bước 6: Cài đặt Pritunl, MongoDB, OpenVPN và WireGuard
# ================================================================
echo "[6/8] Cài đặt Pritunl, MongoDB, OpenVPN và WireGuard..."
sudo apt-get update -y
check_error "apt-get update thất bại"
sudo apt-get install -y pritunl openvpn mongodb-org wireguard wireguard-tools
check_error "Cài đặt gói thất bại"

# ================================================================
# Bước 7: Start và enable services
# ================================================================
echo "[7/8] Khởi động dịch vụ..."
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl start pritunl
sudo systemctl enable pritunl

echo "Kiểm tra trạng thái dịch vụ..."
sudo systemctl status mongod --no-pager || true
sudo systemctl status pritunl --no-pager || true

# ================================================================
# Bước 8: Hiển thị thông tin cấu hình
# ================================================================
echo "[8/8] Hoàn tất cài đặt!"
echo "========================================"
echo ""
echo "Truy cập giao diện web: https://<IP_SERVER>"
echo ""
echo "Lấy setup-key:"
echo "  sudo pritunl setup-key"
echo ""
echo "Lấy mật khẩu mặc định:"
echo "  sudo pritunl default-password"
echo ""
echo "Các cổng đã mở (UFW):"
echo "  - 3389 (RDP)"
echo "  - 22   (SSH)"
echo "  - 192.168.100.0/24 -> 3389 (Guacamole)"
echo ""
echo "Lưu ý:"
echo "  - Nhớ bật UFW sau khi cấu hình xong: sudo ufw enable"
echo "  - Nếu dùng Let's Encrypt SSL, cài certbot và cấu hình trong web UI"
echo "  - Logs: journalctl -u pritunl -f"
echo "========================================"
