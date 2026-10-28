-- Demo data for SPMS. Use only in local development.
USE spms;
SET NAMES utf8mb4;

-- Demo password for all accounts: ChangeMe123!
-- Hash generated for password_hash('ChangeMe123!', PASSWORD_DEFAULT).
-- Regenerate hashes with PHP if authentication rejects this sample hash.
INSERT INTO users (id, full_name, email, password_hash, role) VALUES
(1, 'Quản trị viên Demo', 'admin@example.test', '$2y$12$rWJXWPH2psYnCt6a3b1Mze1ExZf6RMoWyDMZ4KJQJ7fcTNDexKYSK', 'admin'),
(2, 'Giảng viên Demo', 'lecturer@example.test', '$2y$12$rWJXWPH2psYnCt6a3b1Mze1ExZf6RMoWyDMZ4KJQJ7fcTNDexKYSK', 'lecturer'),
(3, 'Sinh viên Demo', 'student@example.test', '$2y$12$rWJXWPH2psYnCt6a3b1Mze1ExZf6RMoWyDMZ4KJQJ7fcTNDexKYSK', 'student');

INSERT INTO lecturers (id, user_id, lecturer_code, department, academic_title)
VALUES (1, 2, 'GV-DEMO-01', 'Công nghệ thông tin', 'Giảng viên');

INSERT INTO students (id, user_id, student_code, class_name, department)
VALUES (1, 3, 'SV-DEMO-01', 'DHTH-DEMO', 'Công nghệ thông tin');

INSERT INTO semesters (id, name, start_date, end_date, status)
VALUES (1, 'Học kỳ Demo 2026', '2026-09-01', '2027-01-31', 'active');

INSERT INTO projects (id, semester_id, title, description, objectives, project_type, status, start_date, due_date, created_by)
VALUES
(1, 1, 'Hệ thống quản lý đồ án sinh viên kết hợp Chatbot',
 'Xây dựng hệ thống web hỗ trợ quản lý đồ án, nhiệm vụ, bài nộp và hỏi đáp.',
 'Quản lý tiến độ minh bạch; hỗ trợ sinh viên tra cứu hướng dẫn.',
 'individual', 'in_progress', '2026-10-01', '2027-01-15', 1);

INSERT INTO project_members (project_id, student_id, member_role)
VALUES (1, 1, 'leader');

INSERT INTO supervisions (project_id, lecturer_id) VALUES (1, 1);

INSERT INTO tasks (id, project_id, title, description, start_date, deadline, status, created_by)
VALUES
(1, 1, 'Phân tích yêu cầu', 'Hoàn thành tài liệu yêu cầu chức năng và phi chức năng.', '2026-10-01', '2026-11-05 23:59:00', 'in_progress', 2),
(2, 1, 'Thiết kế cơ sở dữ liệu', 'Hoàn thành ERD và schema SQL.', '2026-10-10', '2026-11-15 23:59:00', 'todo', 2);

INSERT INTO notifications (user_id, title, content)
VALUES
(3, 'Chào mừng', 'Đây là thông báo demo. Hãy kiểm tra danh sách nhiệm vụ của đồ án.'),
(2, 'Đồ án demo', 'Bạn đang được phân công hướng dẫn đồ án mẫu.');

INSERT INTO chat_sessions (id, user_id, title) VALUES (1, 3, 'Hỏi đáp demo');
INSERT INTO chat_messages (session_id, sender, content) VALUES
(1, 'user', 'Tôi cần làm gì tiếp theo?'),
(1, 'assistant', 'Hãy kiểm tra nhiệm vụ và hạn nộp trên trang tiến độ. Đây là câu trả lời mẫu, chưa kết nối AI.');
