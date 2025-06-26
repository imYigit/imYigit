# Compliance Search ile E-posta Silme Rehberi

**Başlamadan Önce:**

Compliance Search ve e-posta silme işlemleri için yeterli yetkilere sahip olduğunuzdan emin olun. Genellikle **eDiscovery Manager** veya **Compliance Management** gibi uygun rol gruplarında yer almanız gerekir.

---

## 🔍 1. Mevcut Arama Nesnelerini Görüntüle

Öncelikle mevcut Compliance Search nesnelerini görüntüleyerek silme işlemi için uygun olanın var olup olmadığını kontrol edin:

```powershell
Get-ComplianceSearch
````

Belirli bir arama nesnesi hakkında detaylı bilgi almak için:

```powershell
Get-ComplianceSearch | Where-Object { $_.Name -eq "RemovePhishingMessage6" }
```

---

## ✏️ 2. Yeni Bir Compliance Search Nesnesi Oluştur

Eğer uygun bir arama nesnesi yoksa, yeni bir arama tanımlayın. Örneğin, konu satırında belirli bir metni içeren e-postaları aramak için:

```powershell
New-ComplianceSearch -Name "PhishingDeleteSearch" -ExchangeLocation all -ContentMatchQuery "subject:'Bekleyen mesajları hemen düzeltin!' AND Received:today"
```

**Parametreler:**

* `-Name`: Arama nesnesinin adı
* `-ExchangeLocation all`: Tüm posta kutularında arama yapılmasını sağlar
* `-ContentMatchQuery`: Aranacak içerik sorgusu

---

## ▶️ 3. Compliance Search İşlemini Başlat

Tanımladığınız arama nesnesini başlatmak için:

```powershell
Start-ComplianceSearch -Identity "PhishingDeleteSearch"
```

> 🔄 **Not:** Arama işleminin tamamlanması birkaç dakika sürebilir. Bu süre sorgu kapsamına göre değişkenlik gösterebilir.

---

## 📈 4. Arama Durumunu Kontrol Et

Aramanın tamamlanıp tamamlanmadığını kontrol edin:

```powershell
Get-ComplianceSearch -Identity "PhishingDeleteSearch"
```

**Status** değeri `Completed` olmalıdır.

---

## 🧹 5. E-postaları Silme (Purge) İşlemini Başlat

Arama tamamlandıktan sonra e-postaları silmek için:

```powershell
New-ComplianceSearchAction -SearchName "PhishingDeleteSearch" -Purge -PurgeType SoftDelete
```

**Parametreler:**

* `-SearchName`: Daha önce oluşturduğunuz arama nesnesi
* `-Purge`: Silme işlemini başlatır
* `-PurgeType`:

  * `SoftDelete`: Geri alınabilir şekilde siler
  * `HardDelete`: Kalıcı olarak siler (geri alınamaz)

> ⚠️ **Uyarı:** Silme işlemi geri alınamaz etkilere neden olabilir. Komutu uygulamadan önce filtreleme kriterlerinin doğru olduğundan emin olun.

---

## 📊 6. Silme Eyleminin Durumunu Kontrol Et

Silme işleminin tamamlanma durumunu görmek için:

```powershell
Get-ComplianceSearchAction
```

Durum `Completed` olduğunda işlem başarıyla tamamlanmıştır.

---

## 📝 Notlar

* `SoftDelete`: E-postalar geri alınabilir olarak silinir (kurtarılabilir öğeler klasörüne gider).
* `HardDelete`: E-postalar tamamen silinir ve geri getirilemez.
* Compliance Search işlemlerinde yetki eksikliği, ExchangeLocation hataları veya gecikmeler yaşanabilir — yönetici izninizin olduğundan emin olun.
