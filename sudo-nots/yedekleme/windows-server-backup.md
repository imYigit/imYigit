# Windows Server Backup

## Kurulum

```powershell
Install-WindowsFeature Windows-Server-Backup -IncludeManagementTools
```

---

## wbadmin ile Komut Satırı Yedekleme

### Tek Seferlik Tam Yedek

```powershell
# Tüm kritik birimleri harici diske yedekle
wbadmin start backup -backupTarget:E: -allCritical -quiet

# Belirli birimi yedekle
wbadmin start backup -backupTarget:\\NAS\Yedekler -include:C: -quiet
```

### Sistem Durumu Yedeği

```powershell
wbadmin start systemstatebackup -backupTarget:E: -quiet
```

### Zamanlanmış Yedekleme

```powershell
# Günlük 02:00'de yedek al
wbadmin enable backup -addtarget:E: -schedule:02:00 -allCritical -quiet
```

---

## PowerShell ile Yedekleme

```powershell
# Yedekleme politikası oluştur
$policy = New-WBPolicy

# Yedek hedefi ekle (harici disk)
$disk = Get-WBDisk | Where-Object { $_.DiskNumber -eq 1 }
$hedef = New-WBBackupTarget -Disk $disk -Label "Yedek Diski"
Add-WBBackupTarget -Policy $policy -Target $hedef

# Sistem durumunu dahil et
Add-WBSystemState -Policy $policy

# Kritik birimleri dahil et
Add-WBBareMetalRecovery -Policy $policy

# Zamanlama ekle (her gün 02:00)
Set-WBSchedule -Policy $policy -Schedule "02:00"

# Politikayı kaydet ve uygula
Set-WBPolicy -Policy $policy
```

---

## Geri Yükleme

### Dosya Geri Yükleme

```powershell
# Mevcut yedekleri listele
wbadmin get versions -backupTarget:E:

# Belirli dosyayı geri yükle
wbadmin start recovery `
    -version:"12/01/2025-02:00" `
    -itemType:File `
    -items:"C:\Veri\rapor.xlsx" `
    -recoveryTarget:"C:\Kurtarilan" `
    -quiet
```

### Sistem Durumu Geri Yükleme

```powershell
wbadmin start systemstaterecovery -version:"12/01/2025-02:00" -quiet
```

---

## Yedek Durumu Kontrolü

```powershell
# Son yedek bilgisi
wbadmin get status

# Yedekleme geçmişi
wbadmin get versions

# Windows Server Backup olayları
Get-WinEvent -LogName "Microsoft-Windows-Backup" -MaxEvents 20 |
    Select-Object TimeCreated, LevelDisplayName, Message
```
