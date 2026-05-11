# ================================================================
#  VS Code Extensions – Default Profile Remote Deployment
#  Range: B212042 - B212061
#  ACU Kurumsal Dağıtım Scripti
# ================================================================

# ---- 1) Target bilgisayar adları ----
$start = 42
$end   = 61
$prefix = "B212"

$computers = for ($i=$start; $i -le $end; $i++) {
    $num = $i.ToString("000")   # 3 haneli format
    "$prefix$num"
}

Write-Host "Hedef bilgisayarlar:"
$computers | ForEach-Object { Write-Host " - $_" }


# ---- 2) Uzaktan çalıştırılacak payload script ----
$payload = @'
$LogFile = "C:\Windows\Temp\VSCodeExtDeploy.log"

function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $LogFile -Value "$timestamp  $Message"
}

Write-Log "---- VS Code Extension Deployment (Default Profile) Başlıyor ----"

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"
if (!(Test-Path $code)) {
    Write-Log "VS Code bulunamadı. Script sonlandırıldı."
    exit 0
}

Write-Log "VS Code bulundu: $code"

$defaultExtDir = "C:\Users\Default\.vscode\extensions"
if (!(Test-Path "C:\Users\Default")) {
    Write-Log "'C:\Users\Default' profili bulunamadı. Çıkılıyor."
    exit 1
}

if (!(Test-Path $defaultExtDir)) {
    New-Item -ItemType Directory -Path $defaultExtDir -Force | Out-Null
    Write-Log "Default extension klasörü oluşturuldu."
} else {
    Write-Log "Default extension klasörü zaten mevcut."
}

$extensions = @(
    "bmewburn.vscode-intelephense-client",
    "felixfbecker.php-debug",
    "mehedidracula.php-namespace-resolver",
    "neilbrayfield.php-docblocker",
    "junstyle.php-cs-fixer"
)

Write-Log "Yüklenecek extension sayısı: $($extensions.Count)"

foreach ($ext in $extensions) {
    Write-Log "Extension yükleniyor: $ext"

    try {
        & $code --install-extension $ext --extensions-dir $defaultExtDir --force 2>&1 | Out-Null
        Write-Log "OK → $ext yüklendi."
    }
    catch {
        Write-Log "HATA → $ext yüklenemedi. Hata: $($_.Exception.Message)"
    }
}

Write-Log "---- İşlem tamamlandı. ----"
'@

# Payload scripti base64'e çevir
$bytes = [System.Text.Encoding]::Unicode.GetBytes($payload)
$encoded = [Convert]::ToBase64String($bytes)


# ---- 3) Her bilgisayarda uzaktan çalıştır ----
foreach ($pc in $computers) {

    Write-Host ""
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host " $pc üzerinde çalıştırılıyor..." -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan

    # Bilgisayar online mı?
    if (!(Test-Connection -ComputerName $pc -Count 1 -Quiet)) {
        Write-Host "OFFLINE → $pc" -ForegroundColor Yellow
        continue
    }

    try {
        Invoke-Command -ComputerName $pc -ScriptBlock {
            param($script64)
            $decoded = [System.Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($script64))
            Invoke-Expression $decoded
        } -ArgumentList $encoded -ErrorAction Stop

        Write-Host "BAŞARILI → $pc" -ForegroundColor Green
    }
    catch {
        Write-Host "HATA → $pc : $($_.Exception.Message)" -ForegroundColor Red
    }
}
