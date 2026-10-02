# closeall – Chế độ Game

🇻🇳 Tiếng Việt · [🇬🇧 English](#english)

**Tác giả / Author:** Tuan Viet ([@TuanVietCoder](https://github.com/TuanVietCoder))

Một nút bấm tắt hết app/dịch vụ chạy ngầm để chơi game (vd Elden Ring) mượt nhất trên Windows.

## Dùng
Nhấp đúp `CheDoGame.bat` (tự xin quyền Admin) → bấm **TẮT HẾT ĐỂ CHƠI GAME**.
Chơi xong bấm **Chơi xong – bật lại như cũ**.

## Làm gì
- Tắt app đang mở + app chạy ngầm bên thứ 3 (giữ lại Steam, Riot (LMHT/Valorant/Vanguard), anti-cheat, driver, bộ gõ tiếng Việt).
- Tạm dừng dịch vụ Windows ngốn tài nguyên: Update, Search, SysMain, Telemetry, Delivery Optimization, Print Spooler…
- Tắt Defender real-time (nếu Tamper Protection chặn thì mở trang cài đặt để gạt tay).
- Chuyển nguồn sang High Performance.
- Tự mở RivaTuner (RTSS) để khóa FPS nếu máy có cài.

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

---

<a id="english"></a>
# closeall – Game Mode (English)

One button that closes every app and background service so your games (e.g. Elden Ring) run as smoothly as possible on Windows.

## Usage
Double-click `CheDoGame.bat` (it asks for Admin rights) → click **TAT HET DE CHOI GAME** ("close everything to play").
When done, click **Choi xong - bat lai nhu cu** ("done playing – restore everything").

## What it does
- Closes open apps + third-party background apps (keeps Steam, Riot (LoL/Valorant/Vanguard), anti-cheat, drivers, Vietnamese keyboard tools).
- Temporarily stops resource-heavy Windows services: Update, Search, SysMain, Telemetry, Delivery Optimization, Print Spooler…
- Turns off Defender real-time protection (if Tamper Protection blocks it, the settings page opens so you can flip it manually).
- Switches the power plan to High Performance.
- Auto-starts RivaTuner (RTSS) for FPS limiting, if installed.

Edit the `$giuLai` (keep list) / `$dichVu` (services list) at the top of `CheDoGame.ps1` to fit your setup.

## Blocked by Windows after downloading?
Files downloaded from the Internet are marked as "unknown origin", so Windows may block them. To unblock:

1. **Unblock the ZIP before extracting**: right-click the `.zip` → **Properties** → tick **Unblock** → OK → then extract.
   Or, after extracting, open PowerShell in the folder and run:
   ```powershell
   Get-ChildItem | Unblock-File
   ```
2. **SmartScreen says "Windows protected your PC"**: click **More info** → **Run anyway**.
3. **UAC asks for Admin rights**: click **Yes** (needed to stop services + turn off Defender).
4. **Defender/antivirus flags it**: the script turns off real-time protection, so it is sometimes misdetected. **Read `CheDoGame.ps1` first** (it is short, Notepad is enough). If it looks fine, go to *Windows Security → Protection history* → select the blocked item → **Allow on device**.
5. **Smart App Control is on**: Windows blocks downloaded scripts outright, with no allow button. The only way is to turn Smart App Control off, and **once off it cannot be turned back on** without reinstalling Windows. Think carefully before doing this.

> Only download from this repo. Don't run copies sent to you via chat/Drive.

> ⚠️ Save your work first – apps that don't close within 5 seconds are force-killed.
