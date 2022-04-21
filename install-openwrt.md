# write img to disk
    dd if=**.img of=/dev/sdb bs=1M
or use image writer tools to write the disk image to the device
Noramlly, there is two file types images, squashfs and ext4,
1. squashfs
The partition can not be changed,but you can create new partiton for the left space, and mount it.
The system can be reset(factory reset),all chagnes lost
2. ext4
The predifined partions can be changed, so you can enlarege the last partions to add more spaces. 

when to flash the img to the router, first there must be another bootable system attched to the router, so creating a bootable usb would be an option. usually a linux distribution system would be good, it can provider many very powerfull commands. such as partition tools. also using openwrt system is also an option. 
steps:
1. Create a bootable device installed with linux server edition/openwrt.
2. copy the opernwrt to the bootable device
3. using `dd` command to write the img to the target router partition(/dev/sda)
4. optional, using partion command to create partition in the router

# format device using f2fs/ext4 file system 
    mkfs.f2fs /dev/sdb
for the new parttions, it needs to be formated.

# DNS over TLS
use stubby with dnsmasq, alert dnsmasq config

   uci add_list dhcp.@dnsmasq[-1].server='127.0.0.1#5453'
   uci set dhcp.@dnsmasq[-1].noresolv=1
   uci commit && reload_config

