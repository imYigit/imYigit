# Active Directory Parola Politikası

## Varsayılan Domain Politikası

Group Policy Management üzerinden:

```
Bilgisayar Yapılandırması → Politikalar → Windows Ayarları
  → Güvenlik Ayarları → Hesap Politikaları → Parola Politikası
```

| Ayar | Önerilen Değer |
|------|---------------|
| Minimum parola uzunluğu | 12 karakter |
| Parola karmaşıklığı | Etkin |
| Parola geçerlilik süresi | 90 gün |
| Minimum parola geçerlilik süresi | 1 gün |
| Parola geçmişi | 10 parola |

---

## Fine-Grained Password Policy (FGPP)

Belirli kullanıcı veya gruplara farklı politika uygulamak için:

### Politika Oluşturma

```powershell
New-ADFineGrainedPasswordPolicy `
    -Name "YoneticiParolaPolitikasi" `
    -Precedence 10 `
    -MinPasswordLength 16 `
    -PasswordHistoryCount 15 `
    -MaxPasswordAge (New-TimeSpan -Days 60) `
    -MinPasswordAge (New-TimeSpan -Days 1) `
    -ComplexityEnabled $true `
    -ReversibleEncryptionEnabled $false `
    -LockoutThreshold 5 `
    -LockoutDuration (New-TimeSpan -Minutes 30) `
    -LockoutObservationWindow (New-TimeSpan -Minutes 30)
```

### Politikayı Gruba Uygulama

```powershell
Add-ADFineGrainedPasswordPolicySubject `
    -Identity "YoneticiParolaPolitikasi" `
    -Subjects "Domain Admins"
```

### Uygulanan Politikayı Görüntüleme

```powershell
# Kullanıcıya uygulanan politika
Get-ADUserResultantPasswordPolicy -Identity "a.soyad"

# Tüm FGPP politikaları
Get-ADFineGrainedPasswordPolicy -Filter *
```

---

## Hesap Kilitleme Politikası

```
Hesap Politikaları → Hesap Kilitleme Politikası
```

| Ayar | Önerilen Değer |
|------|---------------|
| Kilitleme eşiği | 5 başarısız deneme |
| Kilitleme süresi | 30 dakika |
| Sayacı sıfırlama süresi | 30 dakika |

### Kilitli Hesapları Listeleme

```powershell
Search-ADAccount -LockedOut | Select-Object Name, SamAccountName, LockedOut
```
