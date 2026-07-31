                    Internet
                        │
                        │
                ISP Modem/ONT
              IP : 192.168.1.1
                        │
                 Ethernet (WAN)
                        │
               ether1 (WAN)
        ┌───────────────────────────┐
        │ MikroTik RouterOS         │
        │                           │
        │ bridge-lan                │
        │ 192.168.88.1/24           │
        └─────────────┬─────────────┘
                  ether2
                        │
                        │
                Port 1 Switch
        ┌───────────────────────────┐
        │ Managed Switch            │
        │ H/W Ver : A1              │
        │ Mgmt IP : 192.168.88.2   │
        └───────┬─────────┬─────────┘
            Port2      Port3
              │            │
              │            │
         Fedora Laptop   TP-Link Router
         DHCP Client     Access Point
         192.168.88.x    192.168.88.x