# 2026-07-29 20:42:49 by RouterOS 7.23.2
# software id = 1VJZ-7U0L
#
# model = RB941-2nD
# serial number = HJY0AT5301A
/interface bridge
add name=bridge-lan
/interface wireless
set [ find default-name=wlan1 ] ssid=MikroTik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp-pool ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=dhcp-pool interface=bridge-lan lease-time=1d name=dhcp1
/interface bridge port
add bridge=bridge-lan interface=ether2
/ip address
add address=192.168.88.1/24 interface=bridge-lan network=192.168.88.0
/ip dhcp-client
add interface=ether1 name=client1
/ip dhcp-server network
add address=192.168.88.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.88.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
#error exporting "/ipv6/route" (timeout)
/system clock
set time-zone-name=Asia/Jakarta
/system identity
set name=homelab
