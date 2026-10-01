# Che do Game - 1 nut tat het app/dich vu ngam de choi game muot nhat.
# Tac gia: Tuan Viet - https://github.com/TuanVietCoder/closeall
# Chay bang CheDoGame.bat (tu xin quyen Admin). Sua danh sach duoi day theo y ban.

# Khong bao gio tat: he thong, launcher/anti-cheat, driver am thanh/touchpad/card do hoa
$giuLai = @(
  'explorer','dwm','ShellExperienceHost','StartMenuExperienceHost','SearchHost','TextInputHost',
  'ApplicationFrameHost','LockApp','ctfmon','audiodg',
  'steam','steamwebhelper','steamservice','eldenring','start_protected_game',
  'EasyAntiCheat','EasyAntiCheat_EOS',
  'nvcontainer','NVDisplay.Container','nvsphelper64','NVIDIA Overlay','RadeonSoftware','AMDRSServ',
  'atiesrxx','atieclxx','igfxEM','RtkAudUService64','RtkNGUI64','NahimicSvc64',
  'SynTPEnh','ETDCtrl','ETDTouch','lghub','lghub_agent','RazerCentralService',
  'UniKeyNT','EVKey64','EVKey',   # bo go tieng Viet de chat trong game
  'RTSS','RTSSHooksLoader','RTSSHooksLoader64','EncoderServer','EncoderServer64'   # RivaTuner: hien/gioi han FPS
)

# Dich vu Windows an CPU/o dia khi choi (chi TAM dung, bam "bat lai" hoac khoi dong lai may la chay lai)
$dichVu = @('SysMain','WSearch','DiagTrack','wuauserv','UsoSvc','BITS','DoSvc','Spooler','MapsBroker','WerSvc')

$state = "$env:TEMP\CheDoGame.json"

# Tu xin quyen Admin (can de dung dich vu + tat Defender)
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')
if (-not $admin) {
  Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`"" -Verb RunAs
  exit
}

# Mo RivaTuner (RTSS, khoa FPS) neu chua chay
if (-not (Get-Process RTSS -ErrorAction SilentlyContinue)) {
  $rtss = (Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Unwinder\RTSS' -ErrorAction SilentlyContinue).InstallDir
  if ($rtss -and (Test-Path "$rtss\RTSS.exe")) { Start-Process "$rtss\RTSS.exe" }
}

Add-Type -AssemblyName System.Windows.Forms

# App co cua so + moi app chay ngam cua ben thu 3 (file nam ngoai C:\Windows)
function Lay-DanhSach {
  $sid = (Get-Process -Id $PID).SessionId
  Get-Process | Where-Object {
    $_.Id -ne $PID -and $_.SessionId -eq $sid -and $giuLai -notcontains $_.ProcessName -and
    ($_.MainWindowHandle -ne 0 -or ($_.Path -and $_.Path -notlike "$env:windir\*"))
  }
}

function Defender-Bat { (Get-MpComputerStatus).RealTimeProtectionEnabled }

function Tat-Het {
  $ds = @(Lay-DanhSach)
  # Dong nhe nhang truoc (nhu bam X), cho 5s roi moi ep tat
  foreach ($p in $ds) { try { [void]$p.CloseMainWindow() } catch {} }
  # Dong cac cua so thu muc File Explorer (giu lai taskbar/Start)
  try { (New-Object -ComObject Shell.Application).Windows() | ForEach-Object { $_.Quit() } } catch {}
  $het = (Get-Date).AddSeconds(5)
  while ((Get-Date) -lt $het) { [Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 100 }
  foreach ($p in $ds) { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue }

  $dv = @(Get-Service $dichVu -ErrorAction SilentlyContinue | Where-Object Status -eq 'Running')
  $dv | Stop-Service -Force -ErrorAction SilentlyContinue

  $nguon = [regex]::Match((powercfg /getactivescheme), '[0-9a-fA-F-]{36}').Value
  powercfg /setactive SCHEME_MIN   # High Performance

  # Chi luu trang thai lan dau, bam 2 lan khong ghi de trang thai goc
  if (-not (Test-Path $state)) {
    @{ dichVu = @($dv.Name); nguon = $nguon } | ConvertTo-Json | Set-Content $state
  }

  try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Stop } catch {}
  [GC]::Collect()
  return ($ds.ProcessName | Sort-Object -Unique)
}

function Bat-Lai {
  try { Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop } catch {}
  if (Test-Path $state) {
    $s = Get-Content $state -Raw | ConvertFrom-Json
    foreach ($d in $s.dichVu) { Start-Service $d -ErrorAction SilentlyContinue }
    if ($s.nguon) { powercfg /setactive $s.nguon }
    Remove-Item $state
  }
}

$form = New-Object Windows.Forms.Form -Property @{
  Text = 'Che do Game - by Tuan Viet'; Size = '380,280'; StartPosition = 'CenterScreen'
  FormBorderStyle = 'FixedDialog'; MaximizeBox = $false
}
$nut = New-Object Windows.Forms.Button -Property @{
  Text = "🎮  TAT HET DE CHOI GAME"; Dock = 'Fill'
  Font = New-Object Drawing.Font('Segoe UI', 18, [Drawing.FontStyle]::Bold)
  BackColor = 'Firebrick'; ForeColor = 'White'; FlatStyle = 'Flat'
}
$nutBatLai = New-Object Windows.Forms.Button -Property @{
  Text = 'Choi xong - bat lai nhu cu'; Dock = 'Bottom'; Height = 45
  Font = New-Object Drawing.Font('Segoe UI', 11)
}

$nut.Add_Click({
  $ten = (Lay-DanhSach).ProcessName | Sort-Object -Unique
  $ok = [Windows.Forms.MessageBox]::Show($form,
    "Se tat $(@($ten).Count) app:`n$($ten -join ', ')`n`n+ Tam dung dich vu ngam (Update, Search, SysMain...)`n+ Tat Virus real-time, bat High Performance`n`nHay LUU cong viec truoc! Tiep tuc?",
    'Che do Game', 'YesNo', 'Warning')
  if ($ok -ne 'Yes') { return }
  $nut.Enabled = $false; $nut.Text = 'Dang tat...'; [Windows.Forms.Application]::DoEvents()
  $da = Tat-Het
  $msg = "Da tat $(@($da).Count) app + dich vu ngam. Chuc choi vui!"
  if (Defender-Bat) {
    # Tamper Protection chan tat bang lenh -> mo trang cai dat de gat tay 1 cai
    Start-Process 'windowsdefender://threatsettings'
    $msg += "`n`nWindows chan tat Virus bang lenh. Hay gat 'Real-time protection' sang OFF trong cua so vua mo."
  }
  [void][Windows.Forms.MessageBox]::Show($form, $msg, 'Che do Game')
  $nut.Text = "🎮  DA BAT CHE DO GAME"; $nut.Enabled = $true
})

$nutBatLai.Add_Click({
  Bat-Lai
  $msg = 'Da bat lai dich vu + nguon dien nhu cu.'
  if (-not (Defender-Bat)) {
    Start-Process 'windowsdefender://threatsettings'
    $msg += "`nHay gat 'Real-time protection' sang ON trong cua so vua mo."
  } else { $msg += "`nVirus real-time da BAT lai." }
  [void][Windows.Forms.MessageBox]::Show($form, $msg, 'Che do Game')
  $form.Close()
})

$form.Controls.AddRange(@($nut, $nutBatLai))
$nut.BringToFront()   # de nut to lap phan con lai phia tren nut "bat lai"
[void]$form.ShowDialog()
