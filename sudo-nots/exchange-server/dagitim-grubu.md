# Exchange Dağıtım ve Güvenlik Grubu Yönetimi

## Dağıtım Grubu Oluşturma

```powershell
# Exchange Management Shell'e bağlan (on-prem)
# Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

# Yeni dağıtım grubu
New-DistributionGroup `
    -Name "Muhasebe" `
    -Alias "muhasebe" `
    -PrimarySmtpAddress "muhasebe@domain.com" `
    -OrganizationalUnit "OU=Gruplar,DC=domain,DC=com" `
    -MemberJoinRestriction Closed `
    -MemberDepartRestriction Closed
```

## Üye Yönetimi

```powershell
# Üye ekle
Add-DistributionGroupMember -Identity "Muhasebe" -Member "ali.yilmaz"

# Üye çıkar
Remove-DistributionGroupMember -Identity "Muhasebe" -Member "veli.kaya" -Confirm:$false

# Üyeleri listele
Get-DistributionGroupMember -Identity "Muhasebe" | Select-Object Name, PrimarySmtpAddress
```

---

## Güvenlik Grubu (Posta Etkin)

```powershell
New-DistributionGroup `
    -Name "IT-Ekibi" `
    -Alias "it-ekibi" `
    -Type Security `
    -PrimarySmtpAddress "it@domain.com"
```

---

## Dinamik Dağıtım Grubu

Belirli özelliklere sahip kullanıcıları otomatik kapsar:

```powershell
New-DynamicDistributionGroup `
    -Name "Istanbul-Calisanlar" `
    -Alias "istanbul" `
    -PrimarySmtpAddress "istanbul@domain.com" `
    -RecipientFilter {
        (RecipientType -eq "UserMailbox") -and
        (City -eq "İstanbul") -and
        (Enabled -eq $true)
    }

# Kimin dahil olacağını önizle
Get-Recipient -RecipientPreviewFilter (Get-DynamicDistributionGroup "Istanbul-Calisanlar").RecipientFilter
```

---

## Grup E-posta Ayarları

```powershell
# Grup bilgilerini görüntüle
Get-DistributionGroup -Identity "Muhasebe" | Select-Object *

# Dış gönderime izin ver
Set-DistributionGroup -Identity "Muhasebe" -RequireSenderAuthenticationEnabled $false

# Moderasyon etkinleştir (mesajlar onaydan geçsin)
Set-DistributionGroup -Identity "Muhasebe" `
    -ModerationEnabled $true `
    -ModeratedBy "yonetici@domain.com" `
    -SendModerationNotifications Always

# Gönderim kısıtlaması (sadece belirli gruptan gönderim)
Set-DistributionGroup -Identity "Muhasebe" `
    -AcceptMessagesOnlyFromDLMembers "Yonetim"
```

---

## Microsoft 365 Grupları (Exchange Online)

```powershell
# Microsoft 365 grubuna bağlan
Connect-ExchangeOnline -UserPrincipalName admin@domain.onmicrosoft.com

# M365 grubu oluştur
New-UnifiedGroup `
    -DisplayName "Proje Alfa" `
    -Alias "proje-alfa" `
    -AccessType Private

# Üye ekle
Add-UnifiedGroupLinks -Identity "Proje Alfa" -LinkType Members -Links "kullanici@domain.com"

# Grupları listele
Get-UnifiedGroup | Select-Object DisplayName, PrimarySmtpAddress, AccessType, MemberCount
```
