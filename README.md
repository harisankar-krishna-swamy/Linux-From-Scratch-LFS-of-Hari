# Linux From Scratch | Building a *LFS* by Hari@Vevde:guitar: :guitar: :guitar: 

Steps, Command histories, Logs of build are in this repository

## 1. Host system

Operating System: Debian GNU/Linux 12 with KDE  
Kernel Version: 6.1.0-23-amd64 (64-bit)  
Graphics Platform: X11  
Boot: has EFI  

LFS build guide @ https://www.linuxfromscratch.org/lfs/downloads/stable/LFS-BOOK-12.1-NOCHUNKS.html

## 2. Notes

a) A backup of the host system was taken before build  
b) A *USB drive* was partition with a EFI and ext4 partition for target system   
c) Bash command history files may have overlaps. They were taken during build using history command  
d) All logs of packages in chapters are captured. One or two exceptions are there  
e) Build essentials were already installed on system  

## 3. Bugs fixed with solution / Changes from LFS document

a) LFS Boot stuck at "Loading Linux 6.7.4-lfs-12.1 ..." i.e no display of boot up logs.  
Enable configs `CONFIG_FB_VESA=y` `CONFIG_FB_EFI=y` `CONFIG_FB_SIMPLE=y` and recompile kernel.  
Editing config manually results in make reverting changes as dependant configs are alse needed.  
So use config using `make menuconfig` and Navigate to `> Console drivers > Frame-buffer support > VESA VGA graphics console`

Links to fix issue:  
https://superuser.com/questions/1744258/no-kernel-output-after-booting-lfs  
https://www.linuxquestions.org/questions/linux-general-1/config_fb_vesa-42125/

b) Grub install error on EFI parition not found/supported. 
Installing GRUB on USB needs `removable` option and create config by command like so  
`grub-install --target=x86_64-efi --efi-directory=/boot --removable  
 grub-mkconfig -o /boot/grub/grub.cfg`  

c) LFS install on USB shows "VFS: Cannot open root device /dev/sda2"  
For USB `rootwait` parameter has to be added to `/boot/grub/grub.cfg` linux commands to wait for kernel to load from usb.  
Example `linux   /vmlinuz-6.7.4-lfs-12.1 root=/dev/sda2 rootwait ro`

Link to fix issue: 
https://stackoverflow.com/questions/50479676/linux-kernel-not-able-to-mount-rootfs-from-usb
