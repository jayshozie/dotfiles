


steps to switch out vpn configs:

1. remove the old `wg0` via nmtui
2. add the new config via:
```bash
nmcli connection import type wireguard file /home/jaysh/dev/sysconf/wg0.conf
# change the path accordingly
```
