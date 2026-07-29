# Homelab Mikrotik

Home-lab networking pribadi untuk belajar fondasi networking sebagai basis menuju cybersecurity.

## Hardware & Software
- Router: Mikrotik hAP lite (RB941-2nD)
- RouterOS: 7.23.2
- Laptop: Fedora

## Topologi Dasar
- `ether1` → koneksi ke ISP (DHCP client, dapat IP dari modem/ISP)
- `ether2` → dibridge ke `bridge-lan`, koneksi ke laptop/client
- `wlan1` → interface wireless, SSID masih default (`MikroTik`), **belum** join ke `bridge-lan`

## Ringkasan Konfigurasi (`config-internet-dasar.rsc`)
- Bridge `bridge-lan` dibuat sebagai LAN utama
- `ether2` menjadi port dari `bridge-lan`
- IP LAN: `192.168.88.1/24` di interface `bridge-lan`
- DHCP server (`dhcp1`) membagikan IP dari pool `192.168.88.10-192.168.88.254`, lease time 1 hari
- DNS yang dibagikan ke client: `8.8.8.8`, `1.1.1.1`
- `ether1` sebagai DHCP client — menerima IP dari ISP secara otomatis
- NAT masquerade di `ether1` — supaya client di LAN bisa akses internet
- Timezone: `Asia/Jakarta`
- System identity: `homelab`

## Status Saat Ini
- [x] Internet dasar jalan untuk client yang terhubung ke `ether2` (kabel)
- [ ] WiFi (`wlan1`) belum tersambung ke `bridge-lan` — client WiFi kemungkinan belum dapat IP/internet
- [ ] SSID & password WiFi masih default — belum aman untuk dipakai publik
- [ ] Firewall filter belum ada — baru NAT masquerade, belum ada rule proteksi

## Struktur Repo
- `topology/` — dokumentasi/gambar topologi
- `configs/` — file export config RouterOS (`.rsc`)
- `scripts/` — script automasi (backup config, testing, dll)
- `docs/` — catatan belajar, analisis config, dan troubleshooting

## Tujuan Belajar
Repo ini adalah bagian dari roadmap belajar Networking → Cybersecurity, dengan pendekatan
project-based learning dan trial-and-error — setiap config diuji langsung di hardware nyata,
bukan sekadar simulasi.
