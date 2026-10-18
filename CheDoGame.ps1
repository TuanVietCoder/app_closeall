# Che do Game - 1 nut tat het app/dich vu ngam de choi game muot nhat.
# Tac gia: Tuan Viet - https://github.com/TuanVietCoder/closeall
# Chay bang CheDoGame.bat (tu xin quyen Admin). Sua danh sach duoi day theo y ban.

# Khong bao gio tat: he thong, launcher/anti-cheat, driver, cong cu choi game
$giuLai = @(
  # He thong Windows
  'explorer','dwm','ShellExperienceHost','StartMenuExperienceHost','SearchHost','TextInputHost',
  'ApplicationFrameHost','LockApp','ctfmon','audiodg',
  # Launcher + game + anti-cheat (Riot duoc giu rieng theo thu muc, xem Lay-DanhSach)
  'steam','steamwebhelper','steamservice','eldenring','start_protected_game','modengine2_launcher',
  'EasyAntiCheat','EasyAntiCheat_EOS',
  # Driver card do hoa / am thanh / touchpad / chuot
  'nvcontainer','NVDisplay.Container','nvsphelper64','NVIDIA Overlay','RadeonSoftware','AMDRSServ',
  'atiesrxx','atieclxx','igfxEM','RtkAudUService64','RtkNGUI64','NahimicSvc64',
  'SynTPEnh','ETDCtrl','ETDTouch','lghub','lghub_agent','RazerCentralService',
  # Bo go tieng Viet de chat trong game
  'UniKeyNT','EVKey64','EVKey',
  # Cong cu FPS: RivaTuner, MSI Afterburner, Lossless Scaling
  'RTSS','RTSSHooksLoader','RTSSHooksLoader64','EncoderServer','EncoderServer64',
  'MSIAfterburner','LosslessScaling'
)

# Dich vu Windows an CPU/o dia khi choi (chi TAM dung, bam "bat lai" hoac Restart may la chay lai)
$dichVu = @('SysMain','WSearch','DiagTrack','wuauserv','UsoSvc','BITS','DoSvc','Spooler','MapsBroker','WerSvc')

$state = "$env:TEMP\CheDoGame.json"

# Tu xin quyen Admin (can de dung dich vu)
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
    $_.Path -notlike '*Riot*' -and   # khong dung vao Riot Client/Vanguard/LMHT/Valorant
    ($_.MainWindowHandle -ne 0 -or ($_.Path -and $_.Path -notlike "$env:windir\*"))
  }
}

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

  [GC]::Collect()
  return ($ds.ProcessName | Sort-Object -Unique)
}

function Bat-Lai {
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
    "Se tat $(@($ten).Count) app:`n$($ten -join ', ')`n`n+ Tam dung dich vu ngam (Update, Search, SysMain...)`n+ Bat High Performance`n`nHay LUU cong viec truoc! Tiep tuc?",
    'Che do Game', 'YesNo', 'Warning')
  if ($ok -ne 'Yes') { return }
  $nut.Enabled = $false; $nut.Text = 'Dang tat...'; [Windows.Forms.Application]::DoEvents()
  $da = Tat-Het
  [void][Windows.Forms.MessageBox]::Show($form, "Da tat $(@($da).Count) app + dich vu ngam. Chuc choi vui!", 'Che do Game')
  $nut.Text = "🎮  DA BAT CHE DO GAME"; $nut.Enabled = $true
})

$nutBatLai.Add_Click({
  Bat-Lai
  [void][Windows.Forms.MessageBox]::Show($form, 'Da bat lai dich vu + nguon dien nhu cu.', 'Che do Game')
  $form.Close()
})

$form.Controls.AddRange(@($nut, $nutBatLai))
$nut.BringToFront()   # de nut to lap phan con lai phia tren nut "bat lai"
[void]$form.ShowDialog()
