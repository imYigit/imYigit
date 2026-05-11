# Hyper-V Sanal Switch Yönetimi

## Switch Türleri

| Tür | Açıklama |
|-----|---------|
| **External** | Fiziksel ağa bağlı; VM'ler dışarıya çıkabilir |
| **Internal** | Host ve VM'ler birbiriyle iletişim kurar; dışarıya çıkış yok |
| **Private** | Sadece VM'ler arası iletişim; host dahil değil |

---

## Switch Oluşturma

```powershell
# Harici switch (fiziksel NIC'e bağlı)
$nic = Get-NetAdapter -Name "Ethernet"
New-VMSwitch -Name "Harici Switch" -NetAdapterName $nic.Name -AllowManagementOS $true

# İç switch
New-VMSwitch -Name "İç Switch" -SwitchType Internal

# Özel (private) switch
New-VMSwitch -Name "Özel Switch" -SwitchType Private
```

---

## Switch Yönetimi

```powershell
# Mevcut switchleri listele
Get-VMSwitch | Select-Object Name, SwitchType, NetAdapterInterfaceDescription

# VM'in ağ bağdaştırıcılarını görüntüle
Get-VMNetworkAdapter -VMName "SunucuVM"

# VM'i farklı switch'e bağla
Connect-VMNetworkAdapter -VMName "SunucuVM" -Name "Ağ Bağdaştırıcısı" -SwitchName "Harici Switch"

# Switch'i sil
Remove-VMSwitch -Name "Eski Switch" -Force
```

---

## VLAN Etiketleme (VM Tarafında)

```powershell
# VM ağ bağdaştırıcısına VLAN ID ata
Set-VMNetworkAdapterVlan -VMName "SunucuVM" -Access -VlanId 20

# VLAN durumunu kontrol et
Get-VMNetworkAdapterVlan -VMName "SunucuVM"

# VLAN'ı kaldır
Set-VMNetworkAdapterVlan -VMName "SunucuVM" -Untagged
```

---

## Bant Genişliği Yönetimi

```powershell
# Minimum ve maksimum bant genişliği ayarla (bps)
Set-VMNetworkAdapter -VMName "SunucuVM" `
    -MinimumBandwidthAbsolute 100MB `
    -MaximumBandwidth 1GB

# Ağ bağdaştırıcısı istatistikleri
Get-VMNetworkAdapterStatistics -VMName "SunucuVM"
```
