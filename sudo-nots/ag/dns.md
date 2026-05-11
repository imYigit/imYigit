# Windows DNS Sunucu Yönetimi

## Temel Kavramlar

| Kayıt Türü | Kullanım |
|------------|---------|
| A | Hostname → IPv4 adresi |
| AAAA | Hostname → IPv6 adresi |
| CNAME | Takma ad → başka hostname |
| MX | Mail sunucu kaydı |
| PTR | IP → hostname (ters sorgu) |
| SRV | Servis konum kaydı |

---

## PowerShell ile DNS Yönetimi

### Kayıt Ekleme

```powershell
# A kaydı ekle
Add-DnsServerResourceRecordA `
    -ZoneName "domain.local" `
    -Name "sunucu01" `
    -IPv4Address "192.168.1.10"

# CNAME kaydı ekle
Add-DnsServerResourceRecordCName `
    -ZoneName "domain.local" `
    -Name "dosya" `
    -HostNameAlias "sunucu01.domain.local."

# PTR kaydı ekle (ters bölge)
Add-DnsServerResourceRecordPtr `
    -ZoneName "1.168.192.in-addr.arpa" `
    -Name "10" `
    -PtrDomainName "sunucu01.domain.local."
```

### Kayıt Görüntüleme ve Arama

```powershell
# Bölgedeki tüm kayıtlar
Get-DnsServerResourceRecord -ZoneName "domain.local"

# Belirli kayıt
Get-DnsServerResourceRecord -ZoneName "domain.local" -Name "sunucu01" -RRType A

# Tüm A kayıtları
Get-DnsServerResourceRecord -ZoneName "domain.local" -RRType A
```

### Kayıt Silme

```powershell
Remove-DnsServerResourceRecord `
    -ZoneName "domain.local" `
    -Name "eskiSunucu" `
    -RRType A `
    -RecordData "192.168.1.50" `
    -Force
```

---

## Bölge Yönetimi

### Yeni Birincil Bölge Oluşturma

```powershell
Add-DnsServerPrimaryZone `
    -Name "yenizone.local" `
    -ReplicationScope "Forest" `
    -DynamicUpdate Secure
```

### DNS Önbelleğini Temizleme

```powershell
# Sunucu önbelleği
Clear-DnsServerCache -Force

# İstemci tarafı
Clear-DnsClientCache
```

### DNS Sorgu Testi

```powershell
# Temel sorgu
Resolve-DnsName "sunucu01.domain.local"

# Belirli sunucudan sorgu
Resolve-DnsName "domain.local" -Server "192.168.1.1" -Type MX
```

---

## Koşullu Yönlendirici (Conditional Forwarder)

```powershell
Add-DnsServerConditionalForwarderZone `
    -Name "disalan.com" `
    -MasterServers "8.8.8.8", "8.8.4.4" `
    -ReplicationScope "Forest"
```

---

## Sorun Giderme

```powershell
# DNS sunucu istatistikleri
Get-DnsServerStatistics

# DNS olayları
Get-WinEvent -LogName "DNS Server" -MaxEvents 50

# nslookup alternatifi
Resolve-DnsName "domain.local" -Type SOA
```
