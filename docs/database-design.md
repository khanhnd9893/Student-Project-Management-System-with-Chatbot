# Thiết kế cơ sở dữ liệu

## 1. Tổng quan
Cơ sở dữ liệu: `spms`. Charset: `utf8mb4`. Các bảng nghiệp vụ sử dụng InnoDB để hỗ trợ khóa ngoại và giao dịch.

## 2. Danh sách bảng
| Bảng | Mục đích | Khóa chính / quan hệ |
|---|---|---|
| users | Tài khoản và vai trò | `id`; email unique |
| students | Hồ sơ sinh viên | `user_id` → users |
| lecturers | Hồ sơ giảng viên | `user_id` → users |
| semesters | Học kỳ | `id` |
| projects | Đồ án | `semester_id` → semesters; `created_by` → users |
| project_members | Thành viên đồ án | PK ghép (`project_id`, `student_id`) |
| supervisions | Phân công hướng dẫn | PK ghép (`project_id`, `lecturer_id`) |
| tasks | Nhiệm vụ | `project_id` → projects |
| submissions | Các lần nộp bài | `task_id` → tasks; `student_id` → students |
| feedback | Nhận xét | `submission_id` → submissions; `lecturer_id` → lecturers |
| notifications | Thông báo | `user_id` → users |
| chat_sessions | Phiên chat | `user_id` → users |
| chat_messages | Tin nhắn | `session_id` → chat_sessions |

## 3. Quan hệ chính
- Một `users` có thể có một hồ sơ `students` hoặc một hồ sơ `lecturers`, tùy vai trò.
- Một `semester` có nhiều `projects`.
- `projects` và `students` là quan hệ nhiều-nhiều qua `project_members`.
- `projects` và `lecturers` là quan hệ nhiều-nhiều qua `supervisions`.
- Một `project` có nhiều `tasks`; một `task` có nhiều `submissions`.
- Một `submission` có thể có nhiều `feedback`.
- Một `user` có nhiều `chat_sessions`; một session có nhiều `chat_messages`.

## 4. Quy ước
- Khóa chính dùng `BIGINT UNSIGNED AUTO_INCREMENT` cho bảng chính.
- Thời điểm lưu theo `TIMESTAMP`; quy định múi giờ cần thống nhất ở ứng dụng.
- Mật khẩu chỉ lưu dưới dạng hash trong `password_hash`.
- Tệp không lưu trực tiếp trong database; chỉ lưu tên tệp và metadata. Tệp nên đặt ngoài web root.
- Dữ liệu demo dùng email thuộc miền `.test`, không phải tài khoản thật.

## 5. Chỉ mục và toàn vẹn
Các chỉ mục được thêm cho email, mã sinh viên/giảng viên, trạng thái đề tài, hạn nhiệm vụ, lịch sử nộp và tin nhắn. Khóa ngoại giúp ngăn dữ liệu mồ côi. Ứng dụng vẫn cần kiểm tra nghiệp vụ và quyền truy cập trước khi truy vấn/cập nhật.

## 6. Điểm cần mở rộng
- Bổ sung `audit_logs` để lưu hoạt động quan trọng.
- Bổ sung bảng cấu hình FAQ/nguồn tài liệu chatbot nếu muốn quản lý nội dung từ giao diện.
- Xác định rõ chính sách một sinh viên tham gia bao nhiêu đồ án mỗi học kỳ.
- Xác định quy tắc xóa/lưu trữ đồ án sau khi học kỳ kết thúc.
- Nếu cho phép nhiều lần chấm điểm, thêm phiên bản hoặc trạng thái duyệt cho feedback.

## 7. Khởi tạo
Import `database/schema.sql`, sau đó tùy chọn import `database/seed.sql` để có dữ liệu mẫu.
