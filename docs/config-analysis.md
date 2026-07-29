# Analisis Konfigurasi: `config-internet-dasar.rsc`

Dokumen ini membedah config export dasar dari router hAP lite, baris per baris,
sebagai catatan belajar.

## 1. Bridge
```
/interface bridge
add name=bridge-lan
```
Membuat bridge software bernama `bridge-lan`. Bridge ini nanti jadi "saklar virtual"
tempat interface-interface LAN digabung jadi satu segmen L2.

## 2. Wireless (belum dikonfigurasi penuh)
```
/interface wireless
set [ find default-name=wlan1 ] ssid=MikroTik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
```
SSID diubah tapi masih pakai nama generic `MikroTik` (belum custom), dan security
profile default terlihat belum diberi password/authentication type — artinya WiFi
kemungkinan masih open/tidak aman. **Perlu dicek langsung di router** apakah
security-profile ini sudah punya `wpa2-pre-shared-key` atau belum.

## 3. DHCP Pool & Server
```
/ip pool
add name=dhcp-pool ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=dhcp-pool interface=bridge-lan lease-time=1d name=dhcp1
```
Pool IP yang bisa dipinjamkan ke client: `.10` sampai `.254`. Server DHCP `dhcp1`
mengikat pool ini ke interface `bridge-lan`, lease 1 hari.

## 4. Bridge Port
```
/interface bridge port
add bridge=bridge-lan interface=ether2
```
Hanya `ether2` yang dimasukkan sebagai port ke `bridge-lan`. **`wlan1` tidak ada di
sini** — ini titik penting: artinya client yang connect lewat WiFi belum otomatis
tergabung ke LAN yang sama dan belum akan dapat IP dari `dhcp1`, kecuali `wlan1`
juga ditambahkan sebagai bridge port.

## 5. IP Address LAN
```
/ip address
add address=192.168.88.1/24 interface=bridge-lan network=192.168.88.0
```
Gateway LAN: `192.168.88.1/24`, network `192.168.88.0/24` (254 host tersedia).

## 6. DHCP Client di WAN
```
/ip dhcp-client
add interface=ether1 name=client1
```
`ether1` diset sebagai DHCP client — router meminta IP otomatis dari
ISP/modem yang terhubung di `ether1`.

## 7. DHCP Server Network (opsi yang dibagikan ke client)
```
/ip dhcp-server network
add address=192.168.88.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.88.1
```
Client di LAN akan menerima gateway `192.168.88.1` dan DNS publik Google (`8.8.8.8`)
serta Cloudflare (`1.1.1.1`).

## 8. NAT Masquerade
```
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
```
Ini kunci supaya internet bisa dipakai bersama: semua traffic dari LAN yang keluar
lewat `ether1` di-NAT (masquerade) supaya terlihat seperti berasal dari IP publik
router, bukan IP privat client.

## 9. IPv6 (gagal export)
```
#error exporting "/ipv6/route" (timeout)
```
Baris ini penting dicatat: proses export sempat timeout di bagian IPv6 route.
Bukan berarti konfigurasi rusak, tapi bagian IPv6 tidak ter-export sempurna —
perlu dicek manual (`/ipv6/route print`) kalau butuh detail routing IPv6.

## 10. Clock & Identity
```
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=homelab
```
Timezone diset ke Jakarta (penting untuk akurasi timestamp di log), dan nama
router diubah jadi `homelab` supaya mudah dikenali di Winbox Neighbors.

---

## Kesimpulan Analisis
Config ini adalah **setup internet dasar** yang fungsional untuk client kabel
(`ether2`), tapi punya beberapa titik yang belum lengkap:
1. WiFi (`wlan1`) belum masuk ke `bridge-lan` → perlu ditambahkan sebagai bridge port.
2. Keamanan WiFi (WPA2/password) perlu diverifikasi langsung di router.
3. Belum ada firewall filter rule — baru NAT, belum ada proteksi input/forward.
4. IPv6 route gagal ter-export — perlu dicek manual jika relevan.
