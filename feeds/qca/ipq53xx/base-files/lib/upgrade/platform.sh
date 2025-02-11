. /lib/functions/system.sh

RAMFS_COPY_BIN='fw_printenv fw_setenv'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

platform_check_image() {
	local magic_long="$(get_magic_long "$1")"
	[ "$magic_long" = "73797375" ] && return 0
	return 1
}

platform_do_upgrade() {
	CI_UBIPART="rootfs"
	CI_ROOTPART="ubi_rootfs"
	CI_IPQ807X=1

	board=$(board_name)
	case $board in
	cig,wf189)
		if [ -f /proc/boot_info/bootconfig0/rootfs/upgradepartition ]; then
			CI_UBIPART="$(cat /proc/boot_info/bootconfig0/rootfs/upgradepartition)"
			CI_BOOTCFG=1
		elif [ -f /proc/boot_info/bootconfig1/rootfs/upgradepartition ]; then
			CI_UBIPART="$(cat /proc/boot_info/bootconfig1/rootfs/upgradepartition)"
			CI_BOOTCFG=1
		fi
		nand_upgrade_tar "$1"
		;;
	edgecore,eap105)
		nand_upgrade_tar "$1"
		;;
	esac
}
