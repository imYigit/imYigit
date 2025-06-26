# icacls Komutu Hakkında Her Şey

`icacls`, Windows işletim sisteminde dosya ve klasör izinlerini (ACL - Access Control List) yönetmek için kullanılan güçlü bir komut satırı aracıdır. Özellikle dosya ve klasör izinlerini kaydetmek, düzenlemek ve geri yüklemek için idealdir.

---

## 🔍 **icacls'in Temel Kullanımları**

### 1. **İzinleri Görüntüleme**

Bir dosya veya klasörün izinlerini görmek için:

```bash
icacls "C:\path\to\file_or_folder"

```

### 2. **İzinleri Değiştirme**

Bir kullanıcı veya grup için belirli izinler eklemek:

```bash
icacls "C:\path\to\file_or_folder" /grant UserName:(Permission)

```

**Örnek**: `UserName` kullanıcısına "Tam Denetim" izni vermek:

```bash
icacls "C:\path\to\file_or_folder" /grant UserName:(F)

```

### 3. **İzinleri Kaldırma**

Bir kullanıcı veya grubun izinlerini kaldırmak:

```bash
icacls "C:\path\to\file_or_folder" /remove UserName

```

---

## 📂 **İzinleri Kaydetme ve Geri Yükleme**

### 1. **İzinleri Kaydetmek**

Bir dosya veya klasörün izinlerini bir dosyaya kaydetmek için:

```bash
icacls "D:\DosyaSunucusu\RESTORED-35.Işletme_Mudurlugu" /save "C:\Users\emir.yigit\Desktop\izinler.txt" /T

```

- **`/save`**: İzinleri belirttiğiniz dosyaya kaydeder.
- **`/T`**: Alt klasörler ve dosyalar dahil tüm yapıyı işler.

### 2. **İzinleri Geri Yüklemek**

Kaydedilmiş bir izin dosyasını kullanarak izinleri geri yüklemek:

```bash
icacls "D:\DosyaSunucusu" /restore "C:\Users\admyigit\Desktop\izinler.txt" /T

```

---

## 🔧 **Sık Kullanılan Parametreler**

| **Parametre** | **Açıklama** |
| --- | --- |
| `/grant` | Kullanıcıya izin ekler. Örneğin: `(F)` Tam Denetim, `(R)` Salt Okuma. |
| `/remove` | Kullanıcı veya grubun izinlerini kaldırır. |
| `/save` | İzinleri bir dosyaya kaydeder. |
| `/restore` | Kaydedilmiş izinleri geri yükler. |
| `/inheritance:e` | Miras almayı etkinleştirir. |
| `/inheritance:d` | Miras almayı devre dışı bırakır. |
| `/T` | Alt dosya ve klasörlere komutları uygular. |

---

## 💡 **Pratik Örnekler**

### 1. **Bir Kullanıcıya Tam Denetim Verme**

```bash
icacls "C:\MyFolder" /grant John:(F)

```

### 2. **Sadece Alt Klasörlerde İzinleri Uygulama**

```bash
icacls "C:\MyFolder\*" /grant John:(F) /T

```

### 3. **İzinleri Sadece Okuma Olarak Ayarlama**

```bash
icacls "C:\MyFolder" /grant John:(R)

```

### 4. **İzinleri Bir Dosyaya Kaydetme ve Geri Yükleme**

1. İzinleri kaydet:
    
    ```bash
    icacls "C:\MyFolder\*" /save "C:\permissions.acl" /T
    
    ```
    
2. İzinleri geri yükle:
    
    ```bash
    icacls "C:\MyFolder\*" /restore "C:\permissions.acl" /T
    
    ```
    

---

## ⚠️ **Dikkat Edilmesi Gerekenler**

1. **İşlem Yetkisi**: `icacls` komutlarını çalıştırmak için genellikle yönetici izni gerekir.
2. **Yedekleme**: Geri yükleme yapmadan önce bir yedek oluşturmanız önerilir.
3. **Doğru Yol Yapısı**: Hedef dosya veya klasörlerin kaynak yapıyla tam olarak eşleşmesi gerekir.
