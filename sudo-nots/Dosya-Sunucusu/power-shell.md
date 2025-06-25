# PowerShell Dosya Sunucusu Yönetimi

## Açık Dosyaları ve Klasörleri Listeleme

### PowerShell Komutları

```powershell
# Açık dosyaları ve klasörleri listeleme
Get-SmbOpenFile

```

```powershell
# Belirli bir yol veya desene göre açık dosyaları ve klasörleri listeleme
Get-SmbOpenFile | Where-Object { $_.Path -like "D:\\DosyaSunucusu\\13*" }

```

## Açık Oturumları Listeleme ve Kapatma

### PowerShell Komutları

```powershell
# Açık oturumları listeleme
Get-SmbSession

```

```powershell
# Belirli bir kullanıcıya ait oturumları listeleme
Get-SmbSession | Where-Object { $_.UserName -eq "DOMAIN\\username" }

```

```powershell
# Belirli bir kullanıcıya ait oturumları kapatma
Get-SmbSession | Where-Object { $_.UserName -eq "DOMAIN\\username" } | Close-SmbSession

```

### Komut İstemi (Command Prompt) Komutları

```
# Tüm oturumları listeleme
net session

```

```
# Belirli bir kullanıcıya ait oturumu kapatma
net session \\\\IP_adresi /delete

```

## Üçüncü Taraf Araçlar

- **Process Explorer:** Dosya ve klasörleri kullanıcılar ve işlemler açısından detaylı bir şekilde gösteren bir araçtır.
- **Resource Monitor:** Dosyaların ve klasörlerin kullanıcılar ve işlemler açısından nasıl kullanıldığını gösterir.
