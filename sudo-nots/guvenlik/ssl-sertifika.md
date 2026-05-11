# SSL/TLS Sertifika Yönetimi

## Windows Sertifika Deposu

### Sertifika Listeleme

```powershell
# Kişisel sertifikalar (yerel makine)
Get-ChildItem -Path Cert:\LocalMachine\My | Select-Object Subject, Thumbprint, NotAfter

# Süresi yaklaşan sertifikalar (30 gün içinde)
$limit = (Get-Date).AddDays(30)
Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.NotAfter -lt $limit } |
    Select-Object Subject, NotAfter | Sort-Object NotAfter
```

### Sertifika İçe Aktarma

```powershell
# PFX dosyasından içe aktar
$sifre = ConvertTo-SecureString "SertifikaSifresi" -AsPlainText -Force
Import-PfxCertificate `
    -FilePath "C:\sertifika.pfx" `
    -CertStoreLocation Cert:\LocalMachine\My `
    -Password $sifre

# CER/CRT dosyasından içe aktar (CA sertifikası)
Import-Certificate `
    -FilePath "C:\ca.cer" `
    -CertStoreLocation Cert:\LocalMachine\Root
```

### Sertifika Dışa Aktarma

```powershell
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*sunucu01*" }
$sifre = ConvertTo-SecureString "DışaAktarmaSifresi" -AsPlainText -Force

Export-PfxCertificate `
    -Cert $cert `
    -FilePath "C:\yedek-sertifika.pfx" `
    -Password $sifre
```

---

## Let's Encrypt — Win-ACME ile

```powershell
# Win-ACME indir ve çalıştır
.\wacs.exe --target manual --host "site.domain.com" --installation iis --siteid 1
```

---

## IIS'e Sertifika Bağlama

```powershell
# Sertifika parmak izini al
$parmakIzi = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*domain.com*" }).Thumbprint

# IIS binding güncelle
Import-Module WebAdministration
New-WebBinding -Name "Default Web Site" -Protocol https -Port 443 -HostHeader "www.domain.com"
$binding = Get-WebBinding -Name "Default Web Site" -Protocol https
$binding.AddSslCertificate($parmakIzi, "My")
```

---

## OpenSSL ile Temel İşlemler

```bash
# Sertifika bilgilerini görüntüle
openssl x509 -in sertifika.crt -text -noout

# Sertifika son kullanma tarihi
openssl x509 -in sertifika.crt -noout -dates

# CSR oluşturma
openssl req -new -newkey rsa:2048 -nodes -keyout alan.key -out alan.csr

# PEM'i PFX'e dönüştürme
openssl pkcs12 -export -out sertifika.pfx -inkey alan.key -in alan.crt -certfile ca.crt

# Uzak sunucu sertifikasını kontrol et
openssl s_client -connect domain.com:443 -servername domain.com </dev/null 2>/dev/null | openssl x509 -noout -dates
```

---

## Sertifika İzleme

```powershell
# Tüm sunucularda süresi dolacak sertifikaları raporla
$sunucular = "sunucu01", "sunucu02", "sunucu03"
$limitGun = 60

foreach ($sunucu in $sunucular) {
    Invoke-Command -ComputerName $sunucu -ScriptBlock {
        param($gun)
        $limit = (Get-Date).AddDays($gun)
        Get-ChildItem Cert:\LocalMachine\My |
            Where-Object { $_.NotAfter -lt $limit } |
            Select-Object Subject, NotAfter, @{N="Sunucu";E={$env:COMPUTERNAME}}
    } -ArgumentList $limitGun
}
```
