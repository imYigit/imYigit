**Başlamadan Önce:**

Compliance Search ve e-posta silme işlemi için yeterli yetkilere sahip olduğunuzdan emin olun. Genellikle, **eDiscovery Manager** veya **Compliance Management** gibi uygun gruplarda olmanız gerekmektedir.

---

### **1. Arama Nesnesini Kontrol Et ve Mevcut Nesneleri Görüntüle**

Önce mevcut Compliance Search nesnelerini görüntüleyin ve silme işlemi için uygun olanı bulup bulmadığınızı kontrol edin.

```powershell
Get-ComplianceSearch
```

Eğer spesifik bir arama nesnesi (örneğin, "Remove Phishing Message6") hakkında bilgi almak istiyorsanız:

```powershell
Get-ComplianceSearch | Where-Object { $_.Name -eq "Remove Phishing Message6" }
```

---

### **2. Yeni Bir Compliance Search Nesnesi Oluştur**

Eğer aradığınız nesne mevcut değilse, yeni bir arama nesnesi oluşturun. Bu nesne, silmek istediğiniz e-postaları hedefleyecek bir içerik sorgusu içerir. Örneğin, "phishing" anahtar kelimesini içeren e-postaları bulmak için:

```powershell
New-ComplianceSearch -Name "Spam Delete2" -ExchangeLocation all -ContentMatchQuery "subject:'Bekleyen mesajları hemen düzeltin!' AND Received:today"

```

- **Name**: Arama nesnesinin adı.
- **ExchangeLocation**: Tüm posta kutularını aramak için "all" kullanılır.
- **ContentMatchQuery**: Aranacak içerik sorgusu (örneğin, e-postanın konusu).

---

### **3. Compliance Search İşlemini Başlat**

Compliance Search nesnesini başlatın ve içeriği aramaya başlayın:

```powershell
Start-ComplianceSearch -Identity "Spam Delete2"

```

> Not: Arama işleminin tamamlanmasını bekleyin. Bu süreç, arama kriterlerinin karmaşıklığına ve posta kutusu sayısına bağlı olarak zaman alabilir.
> 

---

### **4. Aramanın Durumunu Kontrol Et**

Arama işleminin tamamlanıp tamamlanmadığını kontrol edin:

```powershell
Get-ComplianceSearch -Identity "Spam Delete2"

```

Eğer işlem tamamlanmışsa, **Status** alanında **Completed** yazmalıdır.

---

### **5. Arama Sonucuna Göre E-posta Silme İşlemini Başlat**

Arama işlemi tamamlandıktan sonra, belirtilen e-postaları silmek için eylemi başlatabilirsiniz. Silme işlemi için şu komutu kullanın:

```powershell
New-ComplianceSearchAction -SearchName "Spam Delete2" -Purge -PurgeType SoftDelete

```

- **SearchName**: Daha önce oluşturduğunuz Compliance Search nesnesinin adı.
- **Purge**: E-postaları silmek için bu parametre kullanılır.
- **PurgeType**: Silme türü; "SoftDelete" kullanırsanız, e-postalar kurtarılabilir olarak işaretlenir.

> Dikkat: Bu işlem geri alınamaz bir etkiye sahip olabilir. Silme işlemi başlatılmadan önce arama kriterlerinin doğru olduğundan emin olun.
> 

---

### **6. Eylemin Durumunu Kontrol Et**

Silme işleminin tamamlanıp tamamlanmadığını kontrol etmek için:

```powershell
Get-ComplianceSearchAction

```

İşlem **Completed** duruma geçtiğinde e-postalar başarıyla silinmiştir.

---

### **Notlar:**

- **SoftDelete**: Bu silme türü ile e-postalar kurtarılabilir durumdadır ve kullanıcılar veya yöneticiler tarafından belirli bir süre içinde geri alınabilir.
- **HardDelete**: E-postaların tamamen silinmesini istiyorsanız, **PurgeType** parametresini **HardDelete** olarak ayarlayabilirsiniz. Ancak bu işlem kalıcıdır ve geri alınamaz.
