# Hyper-V Sanal Makine Yönetimi

## Sanal Makine Oluşturma

```powershell
# Temel VM oluşturma
New-VM `
    -Name "SunucuVM" `
    -MemoryStartupBytes 4GB `
    -Generation 2 `
    -NewVHDPath "D:\VM\SunucuVM\SunucuVM.vhdx" `
    -NewVHDSizeBytes 80GB `
    -SwitchName "Harici Switch"

# DVD sürücüye ISO bağla
Add-VMDvdDrive -VMName "SunucuVM"
Set-VMDvdDrive -VMName "SunucuVM" -Path "C:\ISO\Windows2022.iso"

# Başlatma sırasını ayarla
Set-VMFirmware -VMName "SunucuVM" -BootOrder (Get-VMDvdDrive -VMName "SunucuVM"), (Get-VMHardDiskDrive -VMName "SunucuVM")

# VM'i başlat
Start-VM -Name "SunucuVM"
```

---

## VM Yapılandırma

```powershell
# CPU ve RAM değiştir
Set-VM -Name "SunucuVM" -ProcessorCount 4 -MemoryStartupBytes 8GB

# Dinamik bellek etkinleştir
Set-VMMemory -VMName "SunucuVM" `
    -DynamicMemoryEnabled $true `
    -MinimumBytes 2GB `
    -StartupBytes 4GB `
    -MaximumBytes 16GB

# Ek disk ekle
New-VHD -Path "D:\VM\SunucuVM\Veri.vhdx" -SizeBytes 200GB -Dynamic
Add-VMHardDiskDrive -VMName "SunucuVM" -Path "D:\VM\SunucuVM\Veri.vhdx"

# Ağ adaptörü ekle
Add-VMNetworkAdapter -VMName "SunucuVM" -SwitchName "İç Switch"
```

---

## VM Durumu Yönetimi

```powershell
# Tüm VM'leri listele
Get-VM | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime

# VM başlat / durdur / yeniden başlat
Start-VM -Name "SunucuVM"
Stop-VM -Name "SunucuVM" -Force
Restart-VM -Name "SunucuVM" -Force

# VM'i askıya al (Save State)
Save-VM -Name "SunucuVM"

# Duraklatma
Suspend-VM -Name "SunucuVM"
Resume-VM -Name "SunucuVM"
```

---

## Snapshot (Checkpoint) Yönetimi

```powershell
# Snapshot al
Checkpoint-VM -Name "SunucuVM" -SnapshotName "Guncelleme-Oncesi-$(Get-Date -Format 'yyyyMMdd')"

# Snapshotları listele
Get-VMCheckpoint -VMName "SunucuVM" | Select-Object Name, CreationTime, ParentCheckpointName

# Snapshot'a geri dön
Restore-VMCheckpoint -VMName "SunucuVM" -Name "Guncelleme-Oncesi-20250101"

# Snapshot'u sil
Remove-VMCheckpoint -VMName "SunucuVM" -Name "Guncelleme-Oncesi-20250101"
```

> ⚠️ Snapshot'lar üretim ortamında uzun süre bırakılmamalı — disk performansını olumsuz etkiler.

---

## Canlı Geçiş (Live Migration)

```powershell
# VM'i başka Hyper-V host'una taşı
Move-VM `
    -Name "SunucuVM" `
    -DestinationHost "hyperv02.domain.local" `
    -IncludeStorage `
    -DestinationStoragePath "D:\VM\SunucuVM"
```

---

## Kaynak Kullanımı İzleme

```powershell
# Anlık kaynak kullanımı
Get-VM | Sort-Object CPUUsage -Descending | Select-Object Name, CPUUsage, MemoryAssigned, State

# Hyper-V host kapasitesi
Get-VMHost | Select-Object Name, LogicalProcessorCount, MemoryCapacity, VirtualMachineMigrationEnabled
```
