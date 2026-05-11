# Active Directory Kullanıcı ve Grup Yönetimi

## Kullanıcı İşlemleri

### Yeni Kullanıcı Oluşturma

```powershell
New-ADUser `
    -Name "Ad Soyad" `
    -GivenName "Ad" `
    -Surname "Soyad" `
    -SamAccountName "a.soyad" `
    -UserPrincipalName "a.soyad@domain.local" `
    -Path "OU=Kullanicilar,DC=domain,DC=local" `
    -AccountPassword (ConvertTo-SecureString "Sifre123!" -AsPlainText -Force) `
    -Enabled $true
```

### Kullanıcı Bilgilerini Görüntüleme

```powershell
# Tek kullanıcı
Get-ADUser -Identity "a.soyad" -Properties *

# OU içindeki tüm kullanıcılar
Get-ADUser -Filter * -SearchBase "OU=Kullanicilar,DC=domain,DC=local" | Select-Object Name, SamAccountName, Enabled
```

### Kullanıcı Hesabını Devre Dışı Bırakma

```powershell
Disable-ADAccount -Identity "a.soyad"
```

### Şifre Sıfırlama

```powershell
Set-ADAccountPassword -Identity "a.soyad" `
    -NewPassword (ConvertTo-SecureString "YeniSifre123!" -AsPlainText -Force) `
    -Reset

# Bir sonraki girişte şifre değiştirmeye zorla
Set-ADUser -Identity "a.soyad" -ChangePasswordAtLogon $true
```

### Hesap Kilidini Açma

```powershell
Unlock-ADAccount -Identity "a.soyad"
```

---

## Grup İşlemleri

### Yeni Grup Oluşturma

```powershell
New-ADGroup `
    -Name "Muhasebe" `
    -GroupScope Global `
    -GroupCategory Security `
    -Path "OU=Gruplar,DC=domain,DC=local" `
    -Description "Muhasebe departmanı güvenlik grubu"
```

### Gruba Üye Ekleme / Çıkarma

```powershell
# Üye ekle
Add-ADGroupMember -Identity "Muhasebe" -Members "a.soyad", "b.soyad"

# Üye çıkar
Remove-ADGroupMember -Identity "Muhasebe" -Members "a.soyad" -Confirm:$false
```

### Grup Üyelerini Listeleme

```powershell
Get-ADGroupMember -Identity "Muhasebe" | Select-Object Name, SamAccountName
```

### Kullanıcının Üye Olduğu Gruplar

```powershell
(Get-ADUser -Identity "a.soyad" -Properties MemberOf).MemberOf
```

---

## Toplu İşlemler

### CSV'den Kullanıcı Aktarma

```powershell
Import-Csv "kullanicilar.csv" | ForEach-Object {
    New-ADUser `
        -Name "$($_.Ad) $($_.Soyad)" `
        -GivenName $_.Ad `
        -Surname $_.Soyad `
        -SamAccountName $_.KullaniciAdi `
        -UserPrincipalName "$($_.KullaniciAdi)@domain.local" `
        -Path "OU=Kullanicilar,DC=domain,DC=local" `
        -AccountPassword (ConvertTo-SecureString $_.Sifre -AsPlainText -Force) `
        -Enabled $true
}
```

### Son 90 Günde Giriş Yapmayan Kullanıcılar

```powershell
$tarih = (Get-Date).AddDays(-90)
Get-ADUser -Filter {LastLogonDate -lt $tarih -and Enabled -eq $true} `
    -Properties LastLogonDate | Select-Object Name, LastLogonDate | Sort-Object LastLogonDate
```
