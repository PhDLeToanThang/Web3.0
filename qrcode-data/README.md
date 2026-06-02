# QR Code Auto-Generator cho Form Phỏng Vấn Hộ Gia Đình

Công cụ tự động sinh **2 QR code** cho mỗi hộ gia đình từ file Excel danh sách:

- **QR#1** (`QR_FormID/`) — Mã định danh form phỏng vấn, mỗi hộ một mã duy nhất.
- **QR#2** (`QR_DataLink/`) — Link đến folder chứa dữ liệu của hộ đó (PDF survey, scan 3D, sơ đồ nhà, sổ đỏ...).

---

## Yêu Cầu Hệ Thống

- **Python** 3.8+
- **pip** (trình quản lý gói Python)
- Hệ điều hành: Windows / macOS / Linux

---

## Cài Đặt

### Bước 1 — Clone / Copy project về máy

```bash
cd C:\qrcode
```

### Bước 2 — Cài thư viện

```bash
pip install -r requirements.txt
```

Thư viện gồm: `openpyxl` (đọc Excel), `qrcode[pil]` (tạo QR code), `Pillow` (xử lý ảnh).

---

## Chuẩn Bị Dữ Liệu Đầu Vào (Excel)

File Excel phải có **9 cột**, **theo đúng thứ tự** sau:

| Cột | Tiêu đề | Ví dụ | Ghi chú |
|---|---|---|---|
| A | STT | 1 | Số thứ tự |
| B | Phuong_Xa | Phường An Khánh | Tên phường/xã |
| C | MaPhuong | P01 | Mã viết tắt phường |
| D | ToDP_Thon | Tổ 5 | Tên tổ dân phố/thôn |
| E | MaTo | T05 | Mã viết tắt tổ |
| F | CCCD_ChuHo | 079201234567 | **Căn cước công dân chủ hộ** |
| G | HoVaTen | Nguyễn Văn A | Họ tên chủ hộ |
| H | SoNha_DiaChi | 12/3 Đường A | Địa chỉ |
| I | GhiChu | Có sổ đỏ | Ghi chú (không bắt buộc) |

Có thể dùng file **`sample_data.xlsx`** đã kèm sẵn để chạy thử.

> **Lưu ý:** File Excel để ở **cùng thư mục** với `generate_qr.py` cho dễ chạy.

---

## Cách Chạy

### Trên Windows (khuyên dùng)

Dùng PowerShell wrapper (xử lý lỗi encoding tiếng Việt):

```powershell
.\run.ps1 -ExcelFile sample_data.xlsx
```

Hoặc tự chỉ định file:

```powershell
.\run.ps1 -ExcelFile du_lieu_cua_toi.xlsx
```

### Trên Windows (trực tiếp)

```powershell
$env:PYTHONIOENCODING='utf-8'
python generate_qr.py sample_data.xlsx
```

### Trên macOS / Linux

```bash
python3 generate_qr.py sample_data.xlsx
```

### Kết quả mong đợi

```
Dang doc file: sample_data.xlsx
Tim thay 10 dong du lieu.

[OK]    1 | Nguyễn Văn A         | FormID: P01-T05-079201234567-1052F6
[OK]    2 | Trần Thị B           | FormID: P01-T05-079201234568-1CDADD
...
============================================================
THONG KE:
  - Tong so ho da xu ly: 10
  - QR FormID   : QR_Output\QR_FormID/
  - QR DataLink : QR_Output\QR_DataLink/
  - Folder du lieu: QR_Output\Household_Data/
============================================================
```

---

## Cấu Trúc Đầu Ra

Sau khi chạy, thư mục `QR_Output/` được tạo với cấu trúc:

```
QR_Output/
│
├── QR_FormID/                      ← QR#1: mã định danh form
│   ├── P01-T05-079201234567-1052F6.png
│   ├── P01-T05-079201234568-1CDADD.png
│   └── ...                         (1 file PNG / 1 hộ)
│
├── QR_DataLink/                    ← QR#2: link đến folder dữ liệu
│   ├── P01-T05-079201234567-1052F6_data.png
│   ├── P01-T05-079201234568-1CDADD_data.png
│   └── ...                         (1 file PNG / 1 hộ)
│
└── Household_Data/                 ← Folder dữ liệu từng hộ
    ├── P01_T05_079201234567_001/
    │   ├── link_url.txt            ← Chứa URL & đường dẫn
    │   └── dat_dummy_pdf_here.txt  ← Placeholder: đặt file thật vào đây
    ├── P01_T05_079201234568_002/
    └── ...
```

### Ý nghĩa các file đầu ra

| File | Mục đích |
|---|---|
| `QR_FormID/*.png` | In lên form giấy, scan để truy xuất form |
| `QR_DataLink/*_data.png` | Scan để mở folder chứa dữ liệu hộ đó |
| `Household_Data/*/` | Thả file PDF survey, scan 3D, sơ đồ nhà, sổ đỏ... vào đây |
| `link_url.txt` | Lưu URL web + network path để tiện chia sẻ |

---

## Cách Sinh Mã FormID (QR#1)

```
Công thức:  [MaPhuong] - [MaTo] - [CCCD] - [6 ký tự hash MD5]

Ví dụ:      P01 - T05 - 079201234567 - 1052F6
```

- **MaPhuong + MaTo:** định danh địa bàn
- **CCCD:** định danh chủ hộ
- **6 ký tự hash MD5:** khử trùng trong trường hợp 1 hộ có nhiều đợt khảo sát

**Đảm bảo:** Mỗi FormID là duy nhất toàn hệ thống.

---

## Cách Link Folder Vào QR#2

QR#2 chứa URL web (mặc định là `https://survey.xxx/data/...`).

Khi dùng điện thoại quét QR#2 sẽ mở trình duyệt đến folder dữ liệu của hộ đó.

**Tuỳ chỉnh trong file `generate_qr.py`** (dòng 11-12):

```python
SERVER_PATH = "file:///SERVER/Survey_Data"    # Đường dẫn mạng nội bộ
WEB_URL = "https://survey.xxx/data"           # URL public (website thật)
```

> **Ví dụ thực tế:** Nếu server bạn là `192.168.1.100` — sửa thành:
> ```python
> SERVER_PATH = "file:///192.168.1.100/Survey_Data"
> WEB_URL = "https://192.168.1.100/data"
> ```

---

## Hướng Dẫn Hosting (Chạy Server Web)

Có 2 cách để host dữ liệu để QR#2 hoạt động trên thực tế:

### Cách 1: Server đơn giản (Python HTTP Server) — dùng LAN

```bash
# Mở terminal trong thư mục QR_Output\Household_Data\
cd QR_Output\Household_Data
python -m http.server 8000
```

Sau đó sửa `WEB_URL` trong `generate_qr.py` thành:

```python
WEB_URL = "http://<IP_máy>:8000"
```

Mọi máy trong cùng mạng LAN đều truy cập được. Phù hợp cho **phường/xã nhỏ**.

### Cách 2: Upload lên hosting thật — dùng Internet

**a) Dùng shared hosting (đơn giản nhất)**

- Upload folder `Household_Data/` lên host qua FTP (FileZilla)
- Đường dẫn web sẽ là: `https://tênmiền.com/Household_Data/...`
- Sửa `WEB_URL` tương ứng

**b) Dùng Google Drive / OneDrive**

- Upload folder lên Drive, dùng tool `rclone` hoặc `gdrive` để public
- Hoặc dùng **Google App Script** tạo web service nhẹ

**c) Dùng VPS / Cloud Server (cho 7000+ hộ)**

- Upload lên VPS dùng `rsync` hoặc `scp`
- Cài web server (Nginx / Apache) trỏ vào thư mục dữ liệu

Ví dụ cấu hình **Nginx**:

```nginx
server {
    listen 80;
    server_name survey.xxx;

    root /var/www/survey_data;
    autoindex on;         # Cho phép xem thư mục
    autoindex_exact_size off;
    autoindex_localtime on;
}
```

### Cách 3: Host ngay trên máy Windows (dùng cho nhân viên điền số liệu)

Chạy script `host_data.ps1` (tạo ở dưới) để mở server tạm:

```powershell
# Lưu thành host_data.ps1
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.InterfaceAlias -notlike "*VMware*" }).IPAddress | Select-Object -First 1
Write-Host "Server tai: http://${ip}:8000"
python -m http.server 8000 -d QR_Output\Household_Data
```

Chạy:

```powershell
.\host_data.ps1
```

---

## Quy Trình Thực Tế Khi Triển Khai

### Giai đoạn 1 — Chuẩn bị

```
[Excel danh sách hộ] ──→ [Chạy generate_qr.py] ──→ [QR_Output/]
                                                       │
              ┌────────────────────────────────────────┤
              ▼                                        ▼
         QR_FormID/*.png                          QR_DataLink/*.png
         (in dán vào form giấy)                   (in dán vào folder data)
```

### Giai đoạn 2 — Điều tra thực địa

```
Phỏng vấn hộ gia đình
  → Scan QR#1 trên form → xác định FormID
  → Điền thông tin vào form giấy
  → Scan 3D nhà cửa, chụp sổ đỏ (nếu cho phép)
```

### Giai đoạn 3 — Nhập dữ liệu

```
Sau khi về:
  → Scan form giấy → PDF → đặt vào folder hộ đó
  → Copy file scan 3D, sơ đồ nhà, sổ đỏ vào folder hộ đó
  → QR#2 đã trỏ sẵn vào folder → quét là thấy ngay
```

---

## Mở Rộng / Tuỳ Chỉnh

### Tuỳ chỉnh kích thước QR code

Trong hàm `make_qr_image` (dòng 33-38):

```python
qr = qrcode.QRCode(box_size=8, border=2)  # box_size: lớn hơn = QR to hơn
```

### Xuất danh sách ra Excel kèm FormID

Nếu muốn xuất lại danh sách kèm cột FormID để dễ quản lý:

```python
# Thêm 2 dòng vào cuối hàm process():
from openpyxl import Workbook
wb2 = Workbook(); ws2 = wb2.active
ws2.append(["STT", "HoTen", "CCCD", "FormID", "URL_Data"])
# ... append từng dòng
wb2.save("QR_Output\danh_sach_formid.xlsx")
```

### Tích hợp với Google Sheets

Dùng thư viện `gspread` để đọc dữ liệu từ Google Sheets thay vì Excel:

```bash
pip install gspread oauth2client
```

---

## Xử Lý Lỗi Thường Gặp

### Lỗi encoding tiếng Việt trên Windows

```
UnicodeEncodeError: 'charmap' codec can't encode character
```

→ Luôn chạy qua `run.ps1` hoặc set biến môi trường:

```powershell
$env:PYTHONIOENCODING='utf-8'
```

### Lỗi thiếu thư viện

```
ModuleNotFoundError: No module named 'openpyxl'
```

→ Chạy lại:

```bash
pip install -r requirements.txt
```

### File Excel sai cấu trúc

Script bỏ qua các dòng trống. Kiểm tra các cột **MaPhuong (C)**, **MaTo (E)**, **CCCD (F)** không được để trống.

---

## Liên Hệ & Hỗ Trợ

Mọi thắc mắc vui lòng tạo issue tại repository hoặc liên hệ đội phát triển.
