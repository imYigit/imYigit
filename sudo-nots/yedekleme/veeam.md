# Veeam Backup & Replication — Temel Yönetim

## Yedekleme İşi Oluşturma (PowerShell)

```powershell
# Veeam PowerShell modülünü yükle
Add-PSSnapin VeeamPSSnapIn

# Yedeklenecek VM'i bul
$vm = Find-VBRViEntity -Name "SunucuAdi"

# Yedekleme reposu
$repo = Get-VBRBackupRepository -Name "NAS-Repo"

# Yedekleme işi oluştur
Add-VBRViBackupJob `
    -Name "Gunluk-Yedek" `
    -Entity $vm `
    -BackupRepository $repo
```

---

## Yedekleme İşi Yönetimi

```powershell
# Tüm yedekleme işleri
Get-VBRJob | Select-Object Name, JobType, IsScheduleEnabled, LatestRunLocal

# İşi manuel başlat
Start-VBRJob -Job (Get-VBRJob -Name "Gunluk-Yedek")

# İşi devre dışı bırak
Disable-VBRJob -Job (Get-VBRJob -Name "Gunluk-Yedek")

# Son yedek sonucu
$job = Get-VBRJob -Name "Gunluk-Yedek"
$job.GetLastResult()
```

---

## Geri Yükleme

### Dosya Düzeyinde Geri Yükleme

```powershell
# Son restore noktasını bul
$yedek = Get-VBRBackup -Name "Gunluk-Yedek"
$restorePoint = Get-VBRRestorePoint -Backup $yedek | Sort-Object CreationTime -Descending | Select-Object -First 1

# Dosya geri yükleme oturumu aç
Start-VBRWindowsFileRestore -RestorePoint $restorePoint
```

### Tam VM Geri Yükleme

```powershell
$restorePoint = Get-VBRRestorePoint -Name "SunucuAdi" | Sort-Object CreationTime -Descending | Select-Object -First 1

Start-VBRRestoreVM `
    -RestorePoint $restorePoint `
    -Server (Get-VBRServer -Name "vcenter.domain.local") `
    -PowerUp $false
```

---

## 3-2-1 Yedekleme Kuralı

```
3 kopya veri
  ├── 1 birincil (production)
  ├── 1 yerel yedek (NAS / tape)
  └── 1 uzak yedek (farklı lokasyon / bulut)

2 farklı ortam
  ├── Disk (NAS, SAN)
  └── Bulut / Tape

1 kopya site dışında
  └── Offsite veya cloud (Azure Blob, S3)
```

---

## Yedekleme Sağlığı Kontrolü

```powershell
# Tüm yedekleri listele
Get-VBRBackup | Select-Object Name, CreationTime, TotalSize

# Başarısız işleri bul
Get-VBRJob | Where-Object { $_.GetLastResult() -eq "Failed" } | Select-Object Name

# Repo doluluk durumu
Get-VBRBackupRepository | Select-Object Name, FriendlyPath,
    @{N="Toplam(GB)";E={[math]::Round($_.Info.CachedTotalSpace/1GB,1)}},
    @{N="Kullanılan(GB)";E={[math]::Round($_.Info.CachedFreeSpace/1GB,1) * -1 + [math]::Round($_.Info.CachedTotalSpace/1GB,1)}}
```

---

## Yedekleme Test Checklist

- [ ] Son yedek başarılı mı? (`GetLastResult() -eq "Success"`)
- [ ] Yedek boyutu beklenenden çok küçük değil mi?
- [ ] Repo'da en az 30 günlük yer var mı?
- [ ] Restore testi son 3 ayda yapıldı mı?
- [ ] Offsite kopya güncel mi?
