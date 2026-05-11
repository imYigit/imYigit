# SMB Paylaşımı Oluşturma ve Yönetimi

## Yeni Paylaşım Oluşturma

```powershell
# Temel paylaşım
New-SmbShare `
    -Name "Paylasim" `
    -Path "D:\Paylasim" `
    -Description "Şirket dosya paylaşımı" `
    -FullAccess "DOMAIN\Domain Admins" `
    -ChangeAccess "DOMAIN\Kullanicilar" `
    -ReadAccess "DOMAIN\Misafirler" `
    -FolderEnumerationMode AccessBased

# Gizli paylaşım ($ ile biter)
New-SmbShare -Name "Yedekler$" -Path "E:\Yedekler" -FullAccess "DOMAIN\Yedek-Grubu"
```

---

## Paylaşım Yönetimi

```powershell
# Tüm paylaşımları listele
Get-SmbShare | Select-Object Name, Path, Description

# Paylaşım izinlerini görüntüle
Get-SmbShareAccess -Name "Paylasim"

# İzin ekle
Grant-SmbShareAccess -Name "Paylasim" -AccountName "DOMAIN\YeniGrup" -AccessRight Change -Force

# İzin kaldır
Revoke-SmbShareAccess -Name "Paylasim" -AccountName "DOMAIN\EskiGrup" -Force

# Paylaşımı kaldır
Remove-SmbShare -Name "EskiPaylasim" -Force
```

---

## SMB Sunucu Yapılandırması

```powershell
# SMB sürümlerini görüntüle
Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol, EnableSMB2Protocol

# SMB1'i devre dışı bırak (güvenlik)
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

# İmzalamayı zorunlu kıl
Set-SmbServerConfiguration -RequireSecuritySignature $true -Force

# Boşta bağlantı süresini ayarla (dakika)
Set-SmbServerConfiguration -AutoDisconnectTimeout 15 -Force
```

---

## DFS (Distributed File System) Namespace

```powershell
# DFS rol kurulumu
Install-WindowsFeature FS-DFS-Namespace, FS-DFS-Replication -IncludeManagementTools

# DFS namespace oluştur
New-DfsnRoot `
    -TargetPath "\\sunucu01\Dosyalar" `
    -Type DomainV2 `
    -Path "\\domain.local\Dosyalar"

# Klasör ve hedef ekle
New-DfsnFolder -Path "\\domain.local\Dosyalar\Muhasebe" -TargetPath "\\sunucu01\Muhasebe"
New-DfsnFolderTarget -Path "\\domain.local\Dosyalar\Muhasebe" -TargetPath "\\sunucu02\Muhasebe"
```

---

## Kota ve Dosya Ekranı (FSRM)

```powershell
# FSRM kurulumu
Install-WindowsFeature FS-Resource-Manager -IncludeManagementTools

# Kota oluştur (10 GB, uyarı ver)
New-FsrmQuota -Path "D:\Paylasim\Kullanici1" -Size 10GB -Template "200 MB Limit"

# Dosya ekranı (çalıştırılabilir dosyaları engelle)
New-FsrmFileScreen -Path "D:\Paylasim" -Template "Blok Çalıştırılabilir Dosyaları"
```
