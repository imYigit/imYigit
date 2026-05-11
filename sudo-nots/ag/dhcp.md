# Windows DHCP Sunucu Yönetimi

## Scope Yönetimi

### Yeni Scope Oluşturma

```powershell
Add-DhcpServerv4Scope `
    -Name "Ofis Agi" `
    -StartRange "192.168.10.100" `
    -EndRange "192.168.10.200" `
    -SubnetMask "255.255.255.0" `
    -State Active `
    -LeaseDuration (New-TimeSpan -Days 8)
```

### Scope Seçenekleri (Gateway, DNS)

```powershell
# Varsayılan ağ geçidi
Set-DhcpServerv4OptionValue `
    -ScopeId "192.168.10.0" `
    -Router "192.168.10.1"

# DNS sunucuları
Set-DhcpServerv4OptionValue `
    -ScopeId "192.168.10.0" `
    -DnsServer "192.168.1.10", "192.168.1.11"

# DNS domain adı
Set-DhcpServerv4OptionValue `
    -ScopeId "192.168.10.0" `
    -DnsDomain "domain.local"
```

---

## Hariç Tutma (Exclusion)

```powershell
# Belirli aralığı dağıtımdan çıkar (sunucu IP'leri için)
Add-DhcpServerv4ExclusionRange `
    -ScopeId "192.168.10.0" `
    -StartRange "192.168.10.100" `
    -EndRange "192.168.10.110"
```

---

## Rezervasyon (MAC'e Göre Sabit IP)

```powershell
Add-DhcpServerv4Reservation `
    -ScopeId "192.168.10.0" `
    -IPAddress "192.168.10.150" `
    -ClientId "AA-BB-CC-DD-EE-FF" `
    -Name "Yazici-01" `
    -Description "Ofis yazıcısı"
```

### Mevcut Lease'den Rezervasyon Oluşturma

```powershell
# Önce lease bilgisini al
$lease = Get-DhcpServerv4Lease -ScopeId "192.168.10.0" | Where-Object { $_.HostName -like "*Yazici*" }

# Rezervasyona çevir
Add-DhcpServerv4Reservation `
    -ScopeId "192.168.10.0" `
    -IPAddress $lease.IPAddress `
    -ClientId $lease.ClientId `
    -Name $lease.HostName
```

---

## Lease Yönetimi

```powershell
# Aktif lease'leri listele
Get-DhcpServerv4Lease -ScopeId "192.168.10.0"

# Belirli bir IP'nin lease bilgisi
Get-DhcpServerv4Lease -ScopeId "192.168.10.0" -IPAddress "192.168.10.130"

# Süresi dolmuş lease'leri temizle
Remove-DhcpServerv4Lease -ScopeId "192.168.10.0" -IPAddress "192.168.10.130"
```

---

## DHCP Failover (Yedekli DHCP)

```powershell
Add-DhcpServerv4Failover `
    -Name "Ofis-Failover" `
    -ScopeId "192.168.10.0" `
    -PartnerServer "dhcp02.domain.local" `
    -Mode HotStandby `
    -ServerRole Active `
    -SharedSecret "GizliAnahtar123"
```

---

## Sorun Giderme

```powershell
# DHCP sunucu istatistikleri
Get-DhcpServerv4ScopeStatistics -ScopeId "192.168.10.0"

# Kullanılabilir IP sayısı
(Get-DhcpServerv4ScopeStatistics -ScopeId "192.168.10.0").Free

# DHCP olayları
Get-WinEvent -LogName "Microsoft-Windows-Dhcp-Server/Operational" -MaxEvents 50
```
