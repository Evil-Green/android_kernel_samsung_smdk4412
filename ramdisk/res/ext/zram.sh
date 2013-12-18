#!/sbin/busybox sh

# Init Zram
    chmod 0664 /sys/class/lmk/lowmemorykiller/lmk_state
    chown system system /sys/class/lmk/lowmemorykiller/lmk_state
    chmod 0664 /sys/block/zram0/disksize
    chown system system /sys/block/zram0/disksize
    write /sys/block/zram0/disksize 104857600
#   write /sys/block/zram0/disksize 209715200
#   write /sys/block/zram0/disksize 314572800
#   write /sys/block/zram0/disksize 419430400
#   write /sys/block/zram0/disksize 512040000
#   write /sys/block/zram0/disksize 629145600
#   write /sys/block/zram0/disksize 734003200
#   write /sys/block/zram0/disksize 838860800
    chmod 0664 /sys/block/zram0/initstate
    chown system system /sys/block/zram0/initstate

zram_size=100

if [ -z $2 ];then
	if [ -z $zram_size ]; then
		zram_size=`cat /sys/devices/virtual/block/zram0/disksize`
		zram_size=`expr $zram_size \/ 1024 \/ 1024`
		echo zram_size=$zram_size >> $DEFAULT_PROFILE
	fi
else
	zram_size=$2

	swapoff /dev/block/zram0 > /dev/null 2>&1
	echo 1 > /sys/devices/virtual/block/zram0/reset
        swapoff /dev/block/zram1 > /dev/null 2>&1
	echo 1 > /sys/devices/virtual/block/zram1/reset
        swapoff /dev/block/zram2 > /dev/null 2>&1
	echo 1 > /sys/devices/virtual/block/zram2/reset
        swapoff /dev/block/zram3 > /dev/null 2>&1
	echo 1 > /sys/devices/virtual/block/zram3/reset

	if [ $zram_size -gt 0 ]; then
		echo `expr $zram_size \* 1024 \* 1024` > /sys/devices/virtual/block/zram0/disksize
		mkswap /dev/block/zram0 > /dev/null 2>&1
		swapon /dev/block/zram0 > /dev/null 2>&1
                echo `expr $zram_size \* 1024 \* 1024` > /sys/devices/virtual/block/zram1/disksize
		mkswap /dev/block/zram1 > /dev/null 2>&1
		swapon /dev/block/zram1 > /dev/null 2>&1
                echo `expr $zram_size \* 1024 \* 1024` > /sys/devices/virtual/block/zram2/disksize
		mkswap /dev/block/zram2 > /dev/null 2>&1
		swapon /dev/block/zram2 > /dev/null 2>&1
                echo `expr $zram_size \* 1024 \* 1024` > /sys/devices/virtual/block/zram3/disksize
		mkswap /dev/block/zram3 > /dev/null 2>&1
		swapon /dev/block/zram3 > /dev/null 2>&1
	fi
fi

echo $zram_size
