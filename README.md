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

## Tải về bị Windows chặn?
File tải từ Internet bị Windows đánh dấu "không rõ nguồn gốc", nên có thể bị chặn. Cách mở khóa:

1. **Mở khóa file ZIP trước khi giải nén**: chuột phải file `.zip` → **Properties** → tick **Unblock** → OK → rồi mới giải nén.
   Hoặc sau khi giải nén, mở PowerShell trong thư mục và chạy:
   ```powershell
   Get-ChildItem | Unblock-File
   ```
2. **SmartScreen hiện "Windows protected your PC"**: bấm **More info** → **Run anyway**.
3. **Hộp UAC hỏi quyền Admin**: bấm **Yes** (cần để dừng dịch vụ + tắt Defender).
4. **Defender/antivirus báo nguy hiểm**: script có lệnh tắt real-time protection nên đôi khi bị nhận nhầm. Hãy **đọc `CheDoGame.ps1` trước** (code ngắn, mở bằng Notepad là xem được). Nếu thấy ổn thì vào *Windows Security → Protection history* → chọn mục bị chặn → **Allow on device**.
5. **Smart App Control đang bật** thì Windows chặn hẳn script tải về, không có nút cho phép. Cách duy nhất là tắt Smart App Control, và **tắt rồi thì không bật lại được** nếu không cài lại Windows. Cân nhắc kỹ trước khi làm.

> Chỉ tải từ đúng repo này. Đừng chạy bản do người khác gửi qua chat/Drive.

> ⚠️ Lưu công việc trước khi bấm – app không tự đóng sau 5 giây sẽ bị ép tắt.
