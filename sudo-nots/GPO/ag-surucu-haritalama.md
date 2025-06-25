# Ağ Sürücüsünü Haritalama (Map Etme) ve Kullanıcılara Dağıtım

### **Ağ Sürücüsünü Haritalama (Map Etme) ve Kullanıcılara Dağıtım**

1. **Ağ Sürücüsü Yolu Belirleme**
    - Ağ sürücüsü olarak haritalanacak yolun doğruluğunu kontrol edin.
    Örnek:
        
        ```
        \\domain.local\Paylasim
        
        ```
        
2. **Group Policy Management Console (GPMC) Açma**
    - Domain Controller üzerinde **Group Policy Management** konsolunu açın.
    - Yeni bir **GPO** oluşturun (örneğin: "Ağ Sürücü Dağıtımı").
    - Oluşturulan GPO'ya sağ tıklayın ve **Edit** seçeneğini seçin.
3. **Drive Maps Ayarlarını Yapılandırma**
    - Aşağıdaki yolu izleyin:
        
        ```
        User Configuration → Preferences → Windows Settings → Drive Maps
        
        ```
        
    - Sağ tıklayarak **New** → **Mapped Drive** seçeneğini seçin.
4. **Sürücü Haritalama Ayarları**
    - **General** sekmesinde aşağıdaki ayarları yapın:
        - **Action**: `Create`
        (Yeni bir sürücü oluşturur. Eğer zaten varsa, ayarları günceller.)
        - **Location**:
        Haritalanacak ağ sürücüsünün yolunu yazın:
            
            ```
            \\domain.local\Paylasim
            
            ```
            
        - **Drive Letter**:
        Kullanıcıya atanacak sürücü harfi seçin (örneğin: `Z:`).
        - **Reconnect**: Seçili hale getirin (Kullanıcı yeniden oturum açtığında sürücünün otomatik olarak yeniden bağlanması için).
    - **Label as**: (Opsiyonel) Sürücü için bir isim verin (örneğin: `Paylaşım`).
5. **Hedef Filtreleme (Optional Filtering)**
    - Belirli kullanıcılar veya gruplar için bu ayarı uygulamak isterseniz:
        - **Common** sekmesine gidin ve **Item-level targeting** kutusunu işaretleyin.
        - **Targeting...** butonuna tıklayın ve uygun filtreleme kriterlerini belirleyin (örneğin, belirli bir güvenlik grubu için).
6. **GPO’yu Uygulama**
    - GPO’yu belirli bir **OU** (Organizational Unit) üzerine bağlayın.
    - Örneğin, "Kullanıcılar" OU'suna GPO’yu bağlamak için:
        - **Group Policy Management Console** ekranında ilgili OU'ya sağ tıklayın → **Link an Existing GPO** → "Ağ Sürücü Dağıtımı" GPO'sunu seçin.
7. **GPO’yu Etkinleştirme ve Test Etme**
    - Kullanıcılara GPO'yu dağıtmak için şu komutla politikayı zorlayabilirsiniz:
        
        ```
        gpupdate /force
        
        ```
        
    - Kullanıcılar oturum açtığında **Windows Explorer**’da belirlediğiniz sürücü harfini ve ağı göreceklerdir.

---

### **Notlar ve Öneriler**

- **Replikasyon**: Domain Controller’lar arasında NetLogon ve SYSVOL replikasyonunun düzgün çalıştığından emin olun.
- **Hata Kontrolü**: Kullanıcılar haritalanmış sürücüyü göremiyorsa, şunları kontrol edin:
    - Kullanıcının haritalanacak dizine erişim izinleri (NTFS ve paylaşım izinleri).
    - GPO’nun doğru OU'ya bağlı olup olmadığı.
    - `gpresult /h report.html` komutu ile GPO'nun uygulanıp uygulanmadığını kontrol edin.
