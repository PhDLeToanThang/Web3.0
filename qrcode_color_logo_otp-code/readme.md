# QR Code Color OTP Server

> **Phiên bản:** 1.0.0  
> **Ngôn ngữ:** HTML5 + CSS3 + JavaScript (Vanilla)  
> **Thư viện QR:** [qrcode-generator](https://github.com/kazuhikoarase/qrcode-generator) (CDN)  
> **Nền tảng:** Web Browser (Chrome / Firefox / Edge / Safari)  
> **Dựa trên tài liệu:** [Web3.0/qrcode_color_logo_otp-code](https://github.com/PhDLeToanThang/Web3.0/blob/main/qrcode_color_logo_otp-code/readme_old.md)

---

## Mục lục

- [Tổng quan](#tổng-quan)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Cài đặt & Chạy](#cài-đặt--chạy)
- [Hướng dẫn sử dụng các Form](#hướng-dẫn-sử-dụng-các-form)
  - [Tab 1: Basic — QR Code cơ bản](#tab-1-basic--qr-code-cơ-bản)
  - [Tab 2: OTP — Mã xác thực một lần](#tab-2-otp--mã-xác-thực-một-lần)
  - [Tab 3: GPS — Tọa độ định vị](#tab-3-gps--tọa-độ-định-vị)
  - [Tab 4: ATCOntime — Blueprint Scan](#tab-4-atcontime--blueprint-scan)
- [Khai thác nâng cao](#khai-thác-nâng-cao)
- [Tùy chỉnh & Phát triển](#tùy-chỉnh--phát-triển)
- [License](#license)

---

## Tổng quan

**QR Code Color OTP Server** là một ứng dụng web client-side (chạy hoàn toàn trên trình duyệt, không cần server backend) cho phép:

1. **Tạo mã QR màu sắc** với tùy chọn màu nền, màu foreground.
2. **Chèn Logo** vào trung tâm mã QR (hỗ trợ định dạng PNG, JPG, SVG).
3. **Tích hợp OTP (One-Time Password)** — sinh URL `otpauth://` tương thích Google Authenticator, Authy, Microsoft Authenticator.
4. **Tích hợp GPS** — sinh mã QR chứa tọa độ địa lý (`geo:` URI), hỗ trợ định vị cứu hộ.
5. **Tích hợp ATCOntime** — format dữ liệu Blueprint Scan cho phương tiện di chuyển, hầm trú ẩn.
6. **Xuất file PNG** — tải mã QR đã tạo về máy.

### Đối tượng sử dụng

- **IT Administrators** — tạo mã OTP cho người dùng thiết lập Authenticator.
- **Marketing** — tạo mã QR có thương hiệu (logo + màu sắc công ty).
- **Logistics** — tạo mã QR định vị cho phương tiện, kho bãi.
- **Cứu hộ khẩn cấp** — tạo mã QR chứa tọa độ nơi trú ẩn.

---

## Cấu trúc thư mục

```
QRcode_Color_Otp_Server/
├── index.html              # Trang giao diện chính
├── readme.md               # Tài liệu hướng dẫn (file này)
├── css/
│   └── style.css           # Định nghĩa giao diện (responsive, modern)
├── js/
│   └── script.js           # Logic xử lý QR code, màu sắc, OTP, GPS, ATCOntime
└── images/
    ├── favicon.ico          # Icon tab trình duyệt
    └── default-logo.png     # Logo mặc định (có thể dùng làm mẫu)
```

---

## Yêu cầu hệ thống

| Yêu cầu | Mô tả |
|---------|-------|
| **Trình duyệt** | Chrome 90+, Firefox 90+, Edge 90+, Safari 15+ |
| **JavaScript** | Bật (bắt buộc) |
| **Kết nối Internet** | Cần lần đầu để tải thư viện `qrcode-generator` từ CDN (sau đó có thể cache) |
| **Geolocation** | (Tùy chọn) — cần cấp quyền nếu dùng "Use My Location" |

---

## Cài đặt & Chạy

### Cách 1: Chạy trực tiếp từ file (không cần cài đặt)

1. **Clone** hoặc **tải xuống** toàn bộ thư mục dự án.
2. **Mở file `index.html`** bằng trình duyệt (double-click hoặc kéo thả vào tab trình duyệt).
3. Ứng dụng hoạt động ngay lập tức — tất cả xử lý đều ở phía client (trình duyệt).

### Cách 2: Chạy với HTTP Server (khuyến nghị)

Một số trình duyệt có thể hạn chế File API khi mở file trực tiếp (protocol `file://`).  
Để đảm bảo logo upload hoạt động tốt nhất, nên dùng HTTP server:

```bash
# Dùng Python 3 (có sẵn trên hầu hết hệ thống)
cd QRcode_Color_Otp_Server
python -m http.server 8080
# Mở trình duyệt: http://localhost:8080

# Hoặc dùng Node.js (nếu đã cài)
npx http-server -p 8080

# Hoặc dùng PHP
php -S localhost:8080
```

### Cách 3: Triển khai lên hosting

Upload toàn bộ thư mục lên bất kỳ web server nào (Apache, Nginx, IIS) — không cần cấu hình đặc biệt, vì đây là static site thuần.

---

## Hướng dẫn sử dụng các Form

### Tab 1: Basic — QR Code cơ bản

![Basic Tab](https://via.placeholder.com/600x400/6C5CE7/FFFFFF?text=Basic+Tab+Preview)

#### Các trường nhập liệu

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| **Data / URL** | Textarea (multi-line) | Nhập bất kỳ dữ liệu nào muốn mã hóa: URL, văn bản, số điện thoại, email... |
| **Foreground Color** | Color picker + Text | Màu của các module (ô vuông) trong QR code. Mặc định: `#6C5CE7` (tím). |
| **Background Color** | Color picker + Text | Màu nền của QR code. Mặc định: `#FFFFFF` (trắng). |
| **Logo** | File input | Ảnh logo đặt ở trung tâm. Nhấn **Clear** để xóa. |
| **QR Code Size** | Range slider (150–600px) | Kích thước cạnh của QR code xuất ra. |
| **Auto short URL** | Checkbox | (Tính năng mở rộng) — đánh dấu để kích hoạt rút gọn URL. |

#### Quy trình sử dụng

1. Nhập dữ liệu vào ô **Data / URL**.
2. Chọn màu sắc phù hợp với thương hiệu.
3. (Tùy chọn) Upload logo.
4. Điều chỉnh kích thước.
5. Nhấn **Generate** → QR code hiển thị ở khung Preview bên phải.
6. Nhấn **Download PNG** để tải xuống.

#### Mẹo

- **Error Correction Level H** (cao nhất) được sử dụng mặc định, cho phép logo che phủ ~25% diện tích mà vẫn quét được.
- Nên chọn màu **foreground tối** và **background sáng** để tương phản tốt, đảm bảo scan được.
- Logo được tự động cắt tròn và viền trắng để nổi bật trên nền QR.

---

### Tab 2: OTP — Mã xác thực một lần

![OTP Tab](https://via.placeholder.com/600x400/00b894/FFFFFF?text=OTP+Tab+Preview)

Tính năng này tạo mã QR tương thích chuẩn **TOTP/HOTP** (RFC 6238 / RFC 4226) — có thể quét bằng Google Authenticator, Authy, Microsoft Authenticator, 1Password, Bitwarden.

#### Các trường nhập liệu

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| **OTP Type** | Select (TOTP / HOTP) | **TOTP**: dựa trên thời gian (30s). **HOTP**: dựa trên bộ đếm (counter). |
| **Issuer** | Text | Tên tổ chức / ứng dụng (VD: GitHub, Google, MyApp). |
| **Account Name** | Text | Tên tài khoản người dùng (VD: `user@example.com`). |
| **Secret Key** | Text (monospace) | Khóa bí mật dạng **Base32**. Nhấn **Generate** để tự sinh ngẫu nhiên 32 ký tự. |
| **Digits** | Select (6 / 8) | Số chữ số của mã OTP. |
| **Period** | Select (30 / 60) | Chu kỳ làm mới OTP (chỉ áp dụng cho TOTP). |
| **Counter** | Number | Giá trị bộ đếm (chỉ áp dụng cho HOTP). |

#### Quy trình sử dụng

1. Chọn **OTP Type** (thường để TOTP).
2. Nhập **Issuer** (VD: `Công ty ABC`).
3. Nhập **Account Name** (VD: `nguyenvana@abc.com`).
4. Nhập **Secret Key** hoặc nhấn **Generate** để tự sinh.
5. Chọn **Digits** (6) và **Period** (30).
6. Nhấn **Apply OTP Data to QR**.
   - Hệ thống tự động sinh URL dạng:  
     `otpauth://totp/Công+ty+ABC:nguyenvana@abc.com?secret=JBSWY3DPEHPK3PXP&issuer=Công+ty+ABC&algorithm=SHA1&digits=6&period=30`
   - Dữ liệu được điền vào ô **Data/URL** ở Tab Basic.
7. Chuyển sang Tab Basic, chọn màu sắc, logo, kích thước.
8. Nhấn **Generate** → tạo QR code OTP.
9. Quét mã bằng Authenticator App trên điện thoại.

#### Kiểm tra OTP

Sau khi quét, app Authenticator sẽ hiển thị mã 6 số thay đổi mỗi 30 giây. Dùng Secret Key đã tạo để xác thực OTP trên server của bạn.

---

### Tab 3: GPS — Tọa độ định vị

![GPS Tab](https://via.placeholder.com/600x400/e17055/FFFFFF?text=GPS+Tab+Preview)

Tạo mã QR chứa tọa độ địa lý — hữu ích cho định vị cứu hộ, tìm điểm đến, quản lý tài sản ngoài hiện trường.

#### Các trường nhập liệu

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| **Latitude** | Number (decimal) | Vĩ độ. VD: `10.8231` (TP. HCM). |
| **Longitude** | Number (decimal) | Kinh độ. VD: `106.6297` (TP. HCM). |
| **Location Name** | Text | Tên địa điểm (tùy chọn). VD: `Landmark 81, HCMC`. |

#### Quy trình sử dụng

**Cách 1 — Nhập thủ công:**
1. Nhập **Latitude** và **Longitude**.
2. (Tùy chọn) Nhập **Location Name**.
3. Nhấn **Apply GPS Data to QR**.
   - URL sinh ra dạng: `geo:10.8231,106.6297?q=Landmark%2081%2C%20HCMC`
4. Chuyển sang Tab Basic, tùy chỉnh màu sắc, logo.
5. Nhấn **Generate**.

**Cách 2 — Dùng định vị trình duyệt:**
1. Nhấn **Use My Location**.
2. Trình duyệt yêu cầu cấp quyền truy cập vị trí → chọn **Allow**.
3. Tọa độ hiện tại tự động điền vào các ô.
4. Nhấn **Apply GPS Data to QR**.

#### Ứng dụng thực tế

- **Cứu hộ động đất / sóng thần:** Dán mã QR tại hầm trú ẩn, quét để biết tọa độ chính xác.
- **Quản lý đội xe:** Mỗi phương tiện gắn mã QR chứa GPS bãi đỗ.
- **Du lịch:** Biển chỉ dẫn điểm tham quan kèm tọa độ.

---

### Tab 4: ATCOntime — Blueprint Scan

![ATCOntime Tab](https://via.placeholder.com/600x400/fdcb6e/333333?text=ATCOntime+Tab+Preview)

Format dữ liệu dành cho **Blueprint Scan** — quét nhanh các đối tượng di chuyển (phương tiện, container, tài sản) phục vụ logistics và cứu hộ.

#### Các trường nhập liệu

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| **ATCO Code** | Text | Mã định danh ATCO. VD: `ATCO:123456789`. |
| **Vehicle / Object ID** | Text | ID phương tiện hoặc đối tượng. VD: `BUS-01`, `SHELTER-A12`. |
| **Destination / Route** | Text | Điểm đến hoặc tuyến đường. |
| **Latitude** | Number | Vĩ độ hiện tại của đối tượng. |
| **Longitude** | Number | Kinh độ hiện tại của đối tượng. |
| **Timestamp** | Datetime-local | Thời gian ghi nhận (mặc định: thời điểm hiện tại). |

#### Định dạng dữ liệu ATCOntime

Khi nhấn **Apply ATCOntime Data to QR**, dữ liệu được format theo cấu trúc:

```
ATCO:<code>|VEHICLE:<id>|DEST:<destination>|GPS:<lat>,<lng>|TIME:<ISO-timestamp>
```

Ví dụ:
```
ATCO:123456789|VEHICLE:BUS-01|DEST:Emergency Shelter Zone A|GPS:10.8231,106.6297|TIME:2026-06-03T09:20:00.000Z
```

#### Quy trình sử dụng

1. Nhập **ATCO Code** và/hoặc **Vehicle ID** (bắt buộc ít nhất một).
2. Nhập các thông tin còn lại (tùy chọn).
3. Nhấn **Apply ATCOntime Data to QR**.
4. Chuyển sang Tab Basic để tùy chỉnh giao diện và Generate.

---

## Khai thác nâng cao

### 1. Tạo QR cho WiFi

Nhập trực tiếp vào ô **Data / URL** ở Tab Basic:
```
WIFI:S:MyNetwork;T:WPA;P:MyPassword;;
```

### 2. Tạo QR cho vCard (danh thiếp)

```
BEGIN:VCARD
VERSION:3.0
FN:Nguyen Van A
ORG:Cong ty ABC
TEL:0901234567
EMAIL:nguyenvana@abc.com
END:VCARD
```

### 3. Tạo QR cho Email

```
mailto:nguyenvana@abc.com?subject=Hello&body=Test
```

### 4. Tạo QR cho SMS

```
sms:0901234567?body=Hello
```

### 5. Kết hợp URL Shorten

Để tạo mã QR từ URL ngắn:
1. Rút gọn URL bằng dịch vụ như [UrlHub](https://github.com/realodix/urlhub) hoặc Bitly.
2. Nhập URL ngắn vào ô Data / URL.
3. Generate QR code.

---

## Tùy chỉnh & Phát triển

### Màu sắc chủ đạo

Mở `css/style.css`, tìm biến `--primary`:

```css
:root {
    --primary: #6C5CE7;  /* Đổi sang màu thương hiệu của bạn */
    --success: #00b894;
    --danger: #e17055;
}
```

### Thay đổi Error Correction Level

Mở `js/script.js`, tìm dòng:

```javascript
const qr = qrcode(0, 'H');
```

| Ký tự | Mức sửa lỗi | Khôi phục tối đa |
|-------|-------------|-------------------|
| `L` | Low | ~7% |
| `M` | Medium | ~15% |
| `Q` | Quartile | ~25% |
| `H` | High | ~30% |

> Nếu không dùng logo, có thể giảm xuống `M` hoặc `Q` để tăng dung lượng lưu trữ.

### Thêm định dạng xuất file

Hiện tại chỉ hỗ trợ xuất PNG. Có thể mở rộng thêm:

- **SVG:** vẽ lại QR code bằng SVG thay vì Canvas.
- **PDF:** dùng thư viện `jspdf` + `html2canvas`.
- **EPS:** dùng thư viện chuyên dụng.

---

## License

MIT License — dựa trên tài liệu gốc của **Phd. Le Toan Thang** tại [Web3.0 Repository](https://github.com/PhDLeToanThang/Web3.0/blob/main/qrcode_color_logo_otp-code/readme_old.md).

---

*Xây dựng cho Web3.0 — QR Code thế hệ mới với màu sắc, logo, OTP và định vị.*
