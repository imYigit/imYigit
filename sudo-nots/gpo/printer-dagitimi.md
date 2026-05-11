# GPO ile Yazıcı Dağıtımı

## Yöntem 1: GPO ile Yazıcı Bağlantısı (Push)

### Print Server Gereksinimi

Yazıcıların bir print server üzerinden paylaşılmış olması gerekir:

```
\\sunucu01\Muhasebe-Yazici
\\sunucu01\Ofis-Yazici
```

### GPO Yapılandırması

1. Group Policy Management Console'u aç
2. Yeni GPO oluştur: **"Yazıcı Dağıtımı"**
3. GPO'yu düzenle:

```
Kullanıcı Yapılandırması
  → Tercihler
    → Windows Ayarları
      → Yazıcılar
        → Sağ tık → Yeni → Paylaşılan Yazıcı
```

**Ayarlar:**
- **Eylem:** Update
- **Paylaşım yolu:** `\\sunucu01\Muhasebe-Yazici`
- **Varsayılan yazıcı olarak ayarla:** Gerekirse işaretle

---

## Yöntem 2: Logon Script ile Yazıcı Bağlama

```powershell
# Logon scriptine eklenecek kod
$yazicilar = @{
    "Muhasebe" = "\\sunucu01\Muhasebe-Yazici"
    "Hukuk"    = "\\sunucu01\Hukuk-Yazici"
}

$kullanici = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$gruplar = (New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(sAMAccountName=$($env:USERNAME)))")).FindOne().Properties.memberof

foreach ($grup in $yazicilar.Keys) {
    if ($gruplar -match "CN=$grup,") {
        Add-Printer -ConnectionName $yazicilar[$grup] -ErrorAction SilentlyContinue
    }
}
```

---

## Yazıcı Yönetimi — PowerShell

```powershell
# Sunucudaki paylaşılan yazıcıları listele
Get-Printer -ComputerName "sunucu01" | Select-Object Name, DriverName, PortName, Shared

# Yazıcı sürücüsü kur
Add-PrinterDriver -Name "HP Universal Printing PCL 6"

# Yeni yazıcı port ekle
Add-PrinterPort -Name "IP_192.168.10.50" -PrinterHostAddress "192.168.10.50"

# Yazıcı paylaşıma aç
Add-Printer -Name "Ofis-Yazici" -DriverName "HP Universal Printing PCL 6" -PortName "IP_192.168.10.50" -Shared -ShareName "Ofis-Yazici"

# Yazıcıyı kaldır
Remove-Printer -Name "Eski-Yazici"
```

---

## Sorun Giderme

```powershell
# Print spooler'ı yeniden başlat
Restart-Service -Name Spooler -Force

# Bekleyen tüm işleri temizle
Get-PrintJob -PrinterName "Ofis-Yazici" | Remove-PrintJob

# Yazıcı olayları
Get-WinEvent -LogName "Microsoft-Windows-PrintService/Operational" -MaxEvents 50 |
    Where-Object { $_.LevelDisplayName -eq "Error" }
```
