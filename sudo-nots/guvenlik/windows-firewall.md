# Windows Defender Firewall Yönetimi

## PowerShell ile Kural Yönetimi

### Kural Oluşturma

```powershell
# Gelen bağlantıya izin ver (belirli port)
New-NetFirewallRule `
    -DisplayName "Web Sunucusu HTTP" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 80 `
    -Action Allow `
    -Profile Domain, Private

# Gelen bağlantıya izin ver (belirli program)
New-NetFirewallRule `
    -DisplayName "Uygulama Sunucusu" `
    -Direction Inbound `
    -Program "C:\Apps\sunucu.exe" `
    -Action Allow

# Belirli IP'den gelen trafiği engelle
New-NetFirewallRule `
    -DisplayName "Engelli IP" `
    -Direction Inbound `
    -RemoteAddress "203.0.113.0/24" `
    -Action Block
```

### Kuralları Listeleme ve Filtreleme

```powershell
# Tüm aktif kurallar
Get-NetFirewallRule | Where-Object { $_.Enabled -eq "True" } | Select-Object DisplayName, Direction, Action

# Belirli port kuralları
Get-NetFirewallRule | Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq "3389" }

# Devre dışı kurallar
Get-NetFirewallRule | Where-Object { $_.Enabled -eq "False" } | Select-Object DisplayName
```

### Kural Düzenleme ve Silme

```powershell
# Kuralı devre dışı bırak
Disable-NetFirewallRule -DisplayName "Web Sunucusu HTTP"

# Kuralı sil
Remove-NetFirewallRule -DisplayName "Eski Kural"

# Profil değiştir
Set-NetFirewallRule -DisplayName "Web Sunucusu HTTP" -Profile Domain
```

---

## Profil Yönetimi

```powershell
# Mevcut profil durumları
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

# Domain profilini yapılandır
Set-NetFirewallProfile -Profile Domain `
    -Enabled True `
    -DefaultInboundAction Block `
    -DefaultOutboundAction Allow `
    -LogAllowed False `
    -LogBlocked True `
    -LogFileName "%SystemRoot%\System32\LogFiles\Firewall\pfirewall.log"
```

---

## Sık Kullanılan Port Kuralları

```powershell
# RDP (Remote Desktop)
New-NetFirewallRule -DisplayName "RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow -Profile Domain

# WinRM (PowerShell Remote)
New-NetFirewallRule -DisplayName "WinRM" -Direction Inbound -Protocol TCP -LocalPort 5985, 5986 -Action Allow -Profile Domain

# SMB (Dosya Paylaşımı)
New-NetFirewallRule -DisplayName "SMB" -Direction Inbound -Protocol TCP -LocalPort 445 -Action Allow -Profile Domain

# ICMP (Ping)
New-NetFirewallRule -DisplayName "ICMPv4-Echo" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
```

---

## Bağlantı Testi

```powershell
# Port dinleniyor mu?
Test-NetConnection -ComputerName "sunucu01" -Port 443

# Tüm dinlenen portlar
Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess | Sort-Object LocalPort

# Firewall log analizi
Get-Content "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" | Select-String "DROP"
```
