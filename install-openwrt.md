# write img to disk
    dd if=**.img of=/dev/sdb bs=1M
or use image writer tools to write the disk image to the device
Noramlly, there is two file types images, squashfs and ext4,
1. squashfs
The partition can not be changed,but you can create new partiton for the left space, and mount it.
The system can be reset(factory reset),all chagnes lost
2. ext4
The predifined partions can be changed, so you can enlarege the last partions to add more spaces. 

# format device using f2fs/ext4 file system 
    mkfs.f2fs /dev/sdb
for the new parttions, it needs to be formated.

# DNS over TLS
use stubby with dnsmasq, alert dnsmasq config

   uci add_list dhcp.@dnsmasq[-1].server='127.0.0.1#5453'
   uci set dhcp.@dnsmasq[-1].noresolv=1
   uci commit && reload_config

