# closeall – Chế độ Game

Một nút bấm tắt hết app/dịch vụ chạy ngầm để chơi game (vd Elden Ring) mượt nhất trên Windows.

## Dùng
Nhấp đúp `CheDoGame.bat` (tự xin quyền Admin) → bấm **TẮT HẾT ĐỂ CHƠI GAME**.
Chơi xong bấm **Chơi xong – bật lại như cũ**.

## Làm gì
- Tắt app đang mở + app chạy ngầm bên thứ 3 (giữ lại Steam, anti-cheat, driver, bộ gõ tiếng Việt).
- Tạm dừng dịch vụ Windows ngốn tài nguyên: Update, Search, SysMain, Telemetry, Delivery Optimization, Print Spooler…
- Tắt Defender real-time (nếu Tamper Protection chặn thì mở trang cài đặt để gạt tay).
- Chuyển nguồn sang High Performance.

Sửa danh sách `$giuLai` / `$dichVu` ở đầu `CheDoGame.ps1` theo ý.

> ⚠️ Lưu công việc trước khi bấm – app không tự đóng sau 5 giây sẽ bị ép tắt.
