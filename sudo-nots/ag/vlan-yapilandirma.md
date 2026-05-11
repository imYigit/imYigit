# VLAN Yapılandırması

## Temel Kavramlar

| Terim | Açıklama |
|-------|---------|
| Access Port | Tek VLAN taşıyan port (son kullanıcı cihazları) |
| Trunk Port | Birden fazla VLAN taşıyan port (switch arası, switch-router) |
| Native VLAN | Trunk üzerinde etiketlenmeden geçen VLAN (varsayılan: 1) |
| VLAN ID | 1–4094 arası tanımlayıcı |

---

## Cisco Switch — Temel Yapılandırma

### VLAN Oluşturma

```
Switch# configure terminal
Switch(config)# vlan 10
Switch(config-vlan)# name Ofis
Switch(config-vlan)# vlan 20
Switch(config-vlan)# name Sunucular
Switch(config-vlan)# vlan 30
Switch(config-vlan)# name Misafir
Switch(config-vlan)# exit
```

### Access Port Yapılandırma

```
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# spanning-tree portfast
Switch(config-if)# exit
```

### Trunk Port Yapılandırma (Switch Arası)

```
Switch(config)# interface GigabitEthernet0/24
Switch(config-if)# switchport trunk encapsulation dot1q
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20,30
Switch(config-if)# switchport trunk native vlan 99
Switch(config-if)# exit
```

---

## Router-on-a-Stick (Inter-VLAN Routing)

```
Router(config)# interface GigabitEthernet0/0
Router(config-if)# no shutdown

Router(config)# interface GigabitEthernet0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0

Router(config)# interface GigabitEthernet0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0

Router(config)# interface GigabitEthernet0/0.30
Router(config-subif)# encapsulation dot1Q 30
Router(config-subif)# ip address 192.168.30.1 255.255.255.0
```

---

## Doğrulama Komutları

```
# Tanımlı VLAN'lar
Switch# show vlan brief

# Trunk port detayları
Switch# show interfaces trunk

# Belirli interface durumu
Switch# show interfaces GigabitEthernet0/1 switchport

# MAC adres tablosu
Switch# show mac address-table vlan 10
```

---

## VLAN Planlama Önerileri

| VLAN | Kullanım | IP Bloğu |
|------|---------|---------|
| 1 | Yönetim (sadece yönetim trafiği) | 10.0.0.0/24 |
| 10 | Ofis / Kullanıcı | 192.168.10.0/24 |
| 20 | Sunucular | 192.168.20.0/24 |
| 30 | Misafir Wi-Fi | 192.168.30.0/24 |
| 40 | IP Kamera / IoT | 192.168.40.0/24 |
| 99 | Native (etiketlenmemiş) | — |

> Misafir VLAN'ı diğer VLAN'lardan ACL ile izole edin. Sunucu VLAN'ına sadece gerekli portlar üzerinden erişime izin verin.
