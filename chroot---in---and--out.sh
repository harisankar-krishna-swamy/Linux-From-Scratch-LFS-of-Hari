# On host as root
export LFS=/mnt/lfs && echo $LFS && \
mount -v -t ext4 /dev/sda2 $LFS && \
ls -l $LFS

mkdir -pv $LFS/{dev,proc,sys,run} && \
mount -v --bind /dev $LFS/dev

mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts && \
mount -vt proc proc $LFS/proc && \
mount -vt sysfs sysfs $LFS/sys && \
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login

exec /usr/bin/bash --login

# if boot is added to fstab
mount /boot
#
# To exit from chroot
#
umount /boot
## Then After exit chroot -> unmouting
mountpoint -q $LFS/dev/shm && umount -v $LFS/dev/shm
umount -v $LFS/dev/pts
umount -v $LFS/{sys,proc,run,dev}

umount -v /mnt/lfs
