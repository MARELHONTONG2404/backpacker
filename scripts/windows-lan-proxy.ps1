# Backpacker — buka port WSL ke jaringan LAN (HP / tablet).
# Jalankan sebagai Administrator di PowerShell Windows:
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   D:\codex\base\scripts\windows-lan-proxy.ps1

$ErrorActionPreference = 'Stop'

function Get-WslIp {
    $raw = (wsl hostname -I).Trim()
    if (-not $raw) { throw 'WSL tidak berjalan atau IP tidak ditemukan.' }
    return ($raw -split '\s+')[0]
}

$wslIp = Get-WslIp
Write-Host "WSL IP: $wslIp"

$ports = @(
    @{ Listen = 8080; Name = 'Backpacker-8080' },   # Backend API
    @{ Listen = 8888; Name = 'Backpacker-8888' },   # Mobile gateway (HP)
    @{ Listen = 8890; Name = 'Backpacker-8890' }    # Admin web (Vite)
)

foreach ($p in $ports) {
    $listenPort = $p.Listen
    $ruleName = $p.Name

    netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$listenPort | Out-Null
    netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$listenPort connectaddress=$wslIp connectport=$listenPort
    Write-Host "Portproxy 0.0.0.0:$listenPort -> ${wslIp}:$listenPort"

    if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -LocalPort $listenPort -Protocol TCP -Action Allow | Out-Null
        Write-Host "Firewall rule ditambahkan: $ruleName"
    } else {
        Write-Host "Firewall rule sudah ada: $ruleName"
    }
}

Write-Host ""
Write-Host 'Port forwarding aktif. Akses dari smartphone (Wi-Fi / hotspot SAMA dengan PC):'

$lanIps = @(Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        ($_.IPAddress -like '192.168.*' -or $_.IPAddress -like '10.*') -and
        $_.InterfaceAlias -notlike '*WSL*' -and
        $_.InterfaceAlias -notlike '*Loopback*' -and
        $_.IPAddress -notlike '169.254.*'
    } |
    Select-Object -ExpandProperty IPAddress -Unique)

$defaultRoute = Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
    Sort-Object RouteMetric |
    Select-Object -First 1
$gateway = $defaultRoute.NextHop
$pcIsHotspotClient = ($gateway -like '192.168.137.1') -and ($lanIps -notcontains '192.168.137.1')

if ($pcIsHotspotClient) {
    Write-Host ''
    Write-Host 'PERINGATAN: PC terhubung ke hotspot HP (gateway 192.168.137.1).' -ForegroundColor Yellow
    Write-Host 'Banyak HP tidak bisa membuka layanan di PC saat HP = pembuat hotspot.' -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'Solusi (pilih salah satu):' -ForegroundColor Cyan
    Write-Host '  1. Aktifkan Mobile Hotspot di PC Windows, HP connect ke hotspot PC.'
    Write-Host '     Lalu buka http://192.168.137.1:8888 (mobile) atau :8890 (admin).'
    Write-Host '  2. Sambungkan PC dan HP ke Wi-Fi rumah/kantor yang sama.'
    Write-Host '  3. Matikan mobile data di HP saat uji.'
    Write-Host ''
}

if ($lanIps.Count -eq 0) {
    Write-Host '  Tidak ada IP LAN aktif. Aktifkan Wi-Fi atau Mobile Hotspot di PC.'
} else {
    foreach ($wifiIp in $lanIps) {
        Write-Host ""
        Write-Host "  IP PC: $wifiIp"
        Write-Host "    Mobile (HP): http://${wifiIp}:8888"
        Write-Host "    Admin (HP) : http://${wifiIp}:8890"
        Write-Host "    Backend    : http://${wifiIp}:8080"
    }
}

Write-Host ""
Write-Host 'Catatan:'
Write-Host '  - Jalankan ulang script ini (Admin) setelah restart PC/WSL.'
Write-Host '  - HP harus satu jaringan dengan PC.'
Write-Host '  - Buka Settings > Network > Mobile hotspot di PC jika opsi 1.'
Write-Host ''
netsh interface portproxy show all
