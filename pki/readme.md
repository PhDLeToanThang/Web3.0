# Sơ đồ tổ chức Trình quản lý YubiKey

- Trình quản lý YubiKey
  - Khả năng tương thích đa nền tảng
    - Windows
    - macOS
    - Linux
  - Cấu hình chức năng
    - FIDO2
      - Thiết lập chức năng FIDO2
      - Thay đổi hoặc đặt mã PIN FIDO2
      - Đặt lại mã PIN FIDO2
    - PIV
      - Định cấu hình chức năng PIV
      - Đặt mã PIN và mã PUK PIV
      - Đặt lại PIV về cài đặt gốc
    - YubiKey OTP
      - Định cấu hình hành vi OTP kích hoạt
  - Nhận dạng khóa đơn giản
    - Kiểu máy YubiKey
    - Phiên bản chương trình cơ sở
    - Số sê-ri
  - Bật/Tắt chức năng YubiKey
  - Cắm và chạy
- YubiKey Smart Card Minidriver
  - Đăng ký chứng chỉ Windows gốc
  - Quản lý mã PIN
  - Xác thực thẻ thông minh
 
### Ghi chú:
- Thiết kế của Thẻ Hardware Yubikey là không cho người dùng burn/ update trực tiếp vào Firmware Flash để làm thay đổi cấu trúc định dạng thẻ (thẻ hardware đã được Yubico định dạng vùng
  giống như một số loại thẻ khác:

![image](https://github.com/PhDLeToanThang/Web3.0/assets/106635733/b609b161-5cbc-4ee1-9b70-94da9627e433)

hoặc 

![image](https://github.com/PhDLeToanThang/Web3.0/assets/106635733/84a57f40-0a7e-44eb-81dd-f2b6579e2ad2)

- Mọi thứ không phỉa update firmware thì vẫn có lỗ hổng ở phần mềm Manager for personal.
- Phần mềm cài trên máy PC để xóa, sửa, backup các Store key vẫn có lỗ hổng:

_ví dụ:  Security Advisory YSA-2024-01 YubiKey Manager Privilege Escalation: https://www.yubico.com/support/security-advisories/ysa-2024-01/_

![image](https://github.com/PhDLeToanThang/Web3.0/assets/106635733/d37a611b-0467-480c-ba9a-849fa2582892)





  
