# GPO ile Windows Update Yönetimi (WSUS)

## WSUS Sunucu Kurulumu

```powershell
# WSUS rolü kur
Install-WindowsFeature -Name UpdateServices -IncludeManagementTools

# WSUS yapılandırma sihirbazı
& "C:\Program Files\Update Services\Tools\WsusUtil.exe" postinstall CONTENT_DIR=D:\WSUS
```

---

## GPO ile WSUS Yapılandırması

**Yol:**
```
Bilgisayar Yapılandırması → Yönetim Şablonları
  → Windows Bileşenleri → Windows Update
```

### Önemli Ayarlar

| Politika | Değer |
|---------|-------|
| Otomatik Güncellemeleri Yapılandır | Etkin — `4` (İndir ve zamanla kur) |
| İntranet Microsoft Güncelleme Servis Konumu | `http://wsus.domain.local:8530` |
| Zamanlanmış kurulum günü | `0` (Her gün) |
| Zamanlanmış kurulum saati | `02:00` |
| Otomatik yeniden başlatmayı ertele | Etkin — 4 gün |

---

## WSUS PowerShell Yönetimi

```powershell
# WSUS bağlantısı
$wsus = Get-WsusServer -Name "wsus.domain.local" -PortNumber 8530

# Onay bekleyen güncellemeler
$wsus.GetUpdates() | Where-Object { $_.State -eq "NotApproved" } |
    Select-Object Title, ArrivalDate | Sort-Object ArrivalDate -Descending

# Güncellemeyi onayla
$guncelleme = $wsus.SearchUpdates("KB5021233") | Select-Object -First 1
$hedefGrup = $wsus.GetComputerTargetGroups() | Where-Object { $_.Name -eq "Testciler" }
$guncelleme.Approve("Install", $hedefGrup)

# Bilgisayar güncelleme durumu
$wsus.GetComputerTargets() | ForEach-Object {
    [PSCustomObject]@{
        Bilgisayar   = $_.FullDomainName
        SonKontrol   = $_.LastReportedStatusTime
        BekleyenSayi = ($_.GetUpdateInstallationInfoPerComputerTarget() | Where-Object { $_.UpdateInstallationState -eq "NotInstalled" }).Count
    }
}
```

---

## İstemci Taraflı Kontrol

```powershell
# Güncelleme politikasını zorla
gpupdate /force

# WSUS'a kayıt ol ve rapor gönder
wuauclt /detectnow
wuauclt /reportnow

# Güncelleme geçmişi
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 20

# Bekleyen güncellemeler (Windows Update Agent)
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()
$sonuc = $searcher.Search("IsInstalled=0 and IsHidden=0")
$sonuc.Updates | Select-Object Title
```

---

## Bakım Penceresi Önerileri

```
Sunucular  → Ayda bir, iş dışı saatlerde (Pazar 02:00)
İstemciler → Haftada bir, Salı/Çarşamba gece 23:00 (Patch Tuesday sonrası)
Test grubu → Güncellemeyi 7 gün önce alır, sorun yoksa üretim grubuna onaylanır
```
