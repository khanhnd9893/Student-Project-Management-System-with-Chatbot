# Kiến trúc hệ thống

## 1. Mô hình tổng thể
Phiên bản đề xuất là ứng dụng web PHP theo mô hình phân lớp đơn giản.

```text
Trình duyệt
  ├── HTML / CSS / JavaScript / Bootstrap
  └── HTTP request
          |
          v
      public/index.php
          |
          v
      Routes / Middleware
          |
          v
       Controllers
       ├── AuthController
       ├── ProjectController
       ├── TaskController
       ├── SubmissionController
       └── ChatbotController
          |
          v
       Services / Models
       ├── AuthService
       ├── ProjectService
       ├── SubmissionService
       └── ChatbotService
          |
          +------> MySQL (PDO)
          |
          +------> AI provider API (tùy chọn, qua backend)
```

## 2. Trách nhiệm từng lớp
- **View:** hiển thị dữ liệu; không chứa bí mật hoặc quyết định phân quyền.
- **Controller:** nhận request, xác thực đầu vào, gọi service và trả response.
- **Middleware:** kiểm tra session, vai trò và quyền truy cập.
- **Service:** xử lý nghiệp vụ, quy tắc và tích hợp ngoài.
- **Model/Repository:** truy vấn dữ liệu bằng PDO prepared statements.
- **Database:** ràng buộc toàn vẹn và lưu dữ liệu.
- **ChatbotService:** xử lý FAQ hoặc gọi AI; không được tự ý bỏ qua kiểm tra quyền.

## 3. Luồng đăng nhập
1. Người dùng gửi email và mật khẩu qua HTTPS.
2. Backend tìm tài khoản theo email.
3. So sánh mật khẩu bằng `password_verify()`.
4. Tạo session an toàn, đổi session ID sau đăng nhập.
5. Với mỗi request, backend xác minh session, vai trò và quyền trên bản ghi.
6. Đăng xuất hủy session phía server.

## 4. Luồng nộp bài
1. Sinh viên mở nhiệm vụ thuộc đồ án mình tham gia.
2. Backend xác minh quyền và thời hạn theo quy định.
3. Backend kiểm tra kích thước, MIME và loại tệp cho phép.
4. Lưu tệp bằng tên ngẫu nhiên ở vùng lưu trữ không thực thi.
5. Lưu metadata và thời điểm nộp vào `submissions`.
6. Tạo thông báo cho giảng viên phụ trách.

## 5. Luồng chatbot
1. Xác thực người dùng và giới hạn tần suất gửi.
2. Phân loại câu hỏi: FAQ, hướng dẫn hoặc tra cứu nghiệp vụ.
3. Với FAQ, tìm nội dung đã được duyệt.
4. Với tra cứu cá nhân, truy vấn dữ liệu sau khi kiểm tra quyền.
5. Nếu dùng AI, chỉ gửi ngữ cảnh tối thiểu cần thiết; không gửi bí mật hoặc dữ liệu không được phép.
6. Lưu hội thoại theo chính sách lưu trữ và trả lời kèm giới hạn khi không đủ thông tin.

## 6. Biện pháp bảo mật
- HTTPS ở môi trường triển khai.
- `password_hash()` / `password_verify()`.
- PDO prepared statements.
- CSRF token, output escaping, kiểm tra đầu vào.
- Session cookie `HttpOnly`, `Secure` (khi HTTPS), `SameSite`.
- Kiểm soát quyền ở backend cho từng bản ghi.
- Giới hạn tốc độ chatbot và kích thước request.
- Bí mật qua biến môi trường; không commit vào Git.
- Không cho chạy trực tiếp tệp upload.
- Log lỗi không chứa mật khẩu, token hoặc dữ liệu nhạy cảm.

## 7. Triển khai
- Phát triển: XAMPP hoặc PHP + MySQL local.
- Repository: GitHub.
- Production: máy chủ hỗ trợ PHP và MySQL; cấu hình bí mật bằng môi trường máy chủ.
- GitHub Pages không chạy được backend PHP/MySQL trực tiếp.
