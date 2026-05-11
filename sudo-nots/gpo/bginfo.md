# BGInfo

1. **BGInfo İndirilmesi ve Yapılandırılması**
    - **BGInfo** programını Microsoft'un resmi web sitesinden indirin.
    - Programı çalıştırarak istediğiniz masaüstü bilgi düzenini oluşturun.
    - Düzenlediğiniz yapılandırmayı, **My.bgi** ismiyle kaydedin.
2. **Net Logon İçin Klasör Oluşturma**
    - Domain Controller üzerinde **NetLogon** dizinine gidin:
        
        ```
        \\domain.local\NETLOGON
        
        ```
        
    - **BGInfo** isimli bir klasör oluşturun ve içine aşağıdaki dosyaları yerleştirin:
        - **bginfo.exe**
        - **My.bgi**
        - wallpaper.jpg
3. **Batch Script Oluşturma**
    - Aşağıdaki içeriği kullanarak bir batch dosyası oluşturun:
        
        ```
        @echo off
        REM Merkezi BGInfo dosyalarını çalıştırma
        \\domain.local\NETLOGON\BGInfo\bginfo.exe \\domain.local\NETLOGON\BGInfo\My.bgi /timer:0 /silent /nolicprompt
        
        ```
        
    - Bu dosyayı **NetLogon** klasörüne ekleyin, örneğin **SetBGInfo.bat** ismiyle kaydedin.
4. **Group Policy Kullanarak BGInfo Dağıtımı**
    - Domain Controller üzerinde **Group Policy Management** konsolunu açın.
    - Yeni bir **GPO** oluşturun (örneğin, "BGInfo Uygulama GPO'su").
    - GPO üzerinde sağ tıklayarak **Edit** seçeneğini seçin.
    - Aşağıdaki adımları izleyerek GPO'ya script ekleyin:
        - **User Configuration** → **Policies** → **Windows Settings** → **Scripts (Logon/Logoff)** → **Logon**
        - **Add** butonuna tıklayın ve oluşturduğunuz **SetBGInfo.bat** dosyasının yolunu gösterin:
            
            ```
            \\domain.local\NETLOGON\BGInfo\BGInfo.bat
            
            ```
            
5. **GPO'yu Uygulama**
    - Oluşturduğunuz GPO'yu ilgili OU'lara (Organizational Unit) linkleyin.
    - **gpupdate /force** komutunu çalıştırarak GPO'nun domain bilgisayarlarına uygulanmasını hızlandırabilirsiniz.
6. **Test ve Doğrulama**
    - Bir domain kullanıcısıyla herhangi bir bilgisayarda oturum açarak GPO'nun düzgün çalışıp çalışmadığını doğrulayın.
    - Masaüstünde BGInfo ile yapılandırılmış bilgiler görünecektir.

---

### **Notlar ve Öneriler**

- **BGInfo.exe** ve **My.bgi** dosyalarının NetLogon dizininde olduğundan emin olun.
- GPO'nun doğru OU'lara uygulandığından ve script yolunun doğru yazıldığından emin olun.
- Kullanıcılar oturum açarken herhangi bir gecikme veya hata yaşarsa, scripti debug etmek için log oluşturmayı düşünebilirsiniz.

Bu notları bir dokümana kopyalayarak ileride kolayca erişebilirsiniz.
