#!/bin/bash
# need bash for [[

# set arch
export XBPS_ARCH=x86_64

# static xbps, download to /opt and extract
# for me 59.5 is borked so currently I'm on 56.5, still seems to work ok
STATIC_XBPS_PATH=/opt/xbps-static-static-0.56_5

# remember this is non-reboot patching, so don't include kernel or glibc
EXCLUDE_PACKAGES="linux linux5.4 glibc"

# temporary file names
TMP_CHECK=/tmp/autopatch-check.txt
TMP_UPDATE=/tmp/autopatch-update.txt

FLAGS_UPDATE_REPO="-S"
FLAGS_CHECK="-un"
FLAGS_PIN="-m hold"
FLAGS_UPDATE="-uy -c /tmp/xbps-cache"
FLAGS_UNPIN="-m unhold"

# sometimes we need to do this more than once, so loop forever and break out when no packages found
while true; do

	# refresh repository index
	${STATIC_XBPS_PATH}/usr/bin/xbps-install.static ${FLAGS_UPDATE_REPO}

	# check for updates
	echo Checking for updates...
	${STATIC_XBPS_PATH}/usr/bin/xbps-install.static ${FLAGS_CHECK} >${TMP_CHECK}

	# remove excluded packages
	for PKG in ${EXCLUDE_PACKAGES}; do
		sed -i -e "/^${PKG}-[0-9_.]* /d" ${TMP_CHECK}
	done

	# report number of updates found - if zero, exit (at end loop back)
	NUM_PKGS=$(wc -l <${TMP_CHECK})
	echo Found ${NUM_PKGS} packages for update.

	# if zero packages found, exit script
	if [[ "x${NUM_PKGS}" == "x0" ]]; then
		echo Nothing to do, exiting.
		break
	fi

	# check disk space
	MB_AVAIL=$(df -mP | awk '$6=="/" {print $4}')
	MB_NEED=$(<${TMP_CHECK} awk '{dsz+=($6/1024/1024)} END {print dsz}')
	AVAIL_LE_NEEDED=$(python -c "print( ${MB_AVAIL} <= ${MB_NEED} )")
	if [[ "x${AVAIL_LE_NEEDED}" == "xTrue" ]]; then
		echo Insufficient disk space \(has ${MB_AVAIL} MB, need ${MB_NEED} MB\), exiting.
		break
	fi

	# pin excluded packages
	echo Pinning packages: ${EXCLUDE_PACKAGES}
	for PKG in ${EXCLUDE_PACKAGES}; do
		${STATIC_XBPS_PATH}/usr/bin/xbps-pkgdb.static ${FLAGS_PIN} ${PKG}
	done

	# install updates
	${STATIC_XBPS_PATH}/usr/bin/xbps-install.static ${FLAGS_UPDATE} 2>&1 | logger -t autopatch -s 2>&1

	# unpin excluded packages
	echo Unpinning packages: ${EXCLUDE_PACKAGES}
	for PKG in ${EXCLUDE_PACKAGES}; do
		${STATIC_XBPS_PATH}/usr/bin/xbps-pkgdb.static ${FLAGS_UNPIN} ${PKG}
	done

# end infinite loop
done

