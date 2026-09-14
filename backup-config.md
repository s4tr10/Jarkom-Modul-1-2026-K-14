### Config Router
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
   address 192.218.1.1
   netmask 255.255.255.0

auto eth2
iface eth2 inet static
   address 192.218.2.1
   netmask 255.255.255.0

auto eth3
iface eth3 inet static
   address 192.218.3.1
   netmask 255.255.255.0
```

### Config Entity Alice
```
auto eth0
iface eth0 inet static
   address 192.218.1.2
   netmask 255.255.255.0
   gateway 192.218.1.1
```
### Config Entity Mika
```
auto eth0
iface eth0 inet static
   address 192.218.1.3
   netmask 255.255.255.0
   gateway 192.218.1.1
```
### Config Entity Chisa
```
auto eth0
iface eth0 inet static
   address 192.218.2.2
   netmask 255.255.255.0
   gateway 192.218.1.1
```
### Config Entity Knights
```
auto eth0
iface eth0 inet static
   address 192.218.3.2
   netmask 255.255.255.0
   gateway 192.218.1.1
```
### Config Entity Eiri    
```
auto eth0
iface eth0 inet static
   address 192.218.3.3
   netmask 255.255.255.0
   gateway 192.218.1.1
```