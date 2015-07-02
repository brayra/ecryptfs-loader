#!/bin/bash

PROG=`basename $0`
usage()
{
	echo "usage: $PROG CMD"
	echo ' install        : command to install'
	echo ' uninstall      : command to uninstall'
	echo ''
	echo '       -h       : display this help'
	echo ''
	echo ''
}

# error <error-code> <msg> ...
# if the error code is greater than zero, print the rest
# of the arguments as an error message. If no msg is given
# print "Unknown Error".
error()
{
	NUM="$#"
	if [ $NUM -gt 0 ] && [ "$1" -gt 0 ] ; then
		ERR_NUM=$1
		shift
		NUM="$#"
		if [ $NUM -gt 0 ] ; then
			MSG="$*"
		else
			MSG="Unknown Error"
		fi
		echo "ERROR($ERR_NUM): $*" >&2
		exit $ERR_NUM
	fi
}


CMD=
while getopts ":kh" opt; do
	case $opt in 
		k  ) CODE=1;;
		h  ) usage
				exit 1
				;;
		\? ) usage
				exit 1
	esac
done
shift $(($OPTIND -1))

if [ $UID -ne 0 ] ; then 
	usage
	echo "must be root"
	exit 2
fi

if [ $# -gt 0 ] ; then
	CMD=$1
fi

if [ "$CMD" = "" ] ; then
	usage
	exit 1
fi

copy_files()
{
	echo "Installing Files..."
	errors=0
	cp mime/ecryptfsloader-ecryptfs.xml /usr/share/ecryptfs-loader
  [ $? -ne 0 ] && errors=1	
	cp bin/ecryptfs-loader /usr/bin
  [ $? -ne 0 ] && errors=1	
	chmod a+x /usr/bin/ecryptfs-loader
  [ $? -ne 0 ] && errors=1	
	cp desktop/ecryptfs-loader.desktop /usr/share/applications
  [ $? -ne 0 ] && errors=1	
	return $errors
}

remove_files()
{
	echo "Removing files..."
	rm -f /usr/bin/ecryptfs-loader >/dev/null 2>/dev/null
	rm -f /usr/share/ecryptfs-loader/ecryptfsloader-ecryptfs.xml >/dev/null 2>/dev/null
	rm -f /usr/share/applications/ecryptfs-loader.desktop >/dev/null 2>/dev/null
	rmdir /usr/share/ecryptfs-loader >/dev/null 2>/dev/null
}

case $CMD in
	install)
		
		if ! [ -f /usr/bin/encfs ] ; then
			echo "ERROR: encfs is required"
			echo ""
			echo "Install ecnfs with 'sudo apt-get install encfs'"
			echo ""
			exit 3
		fi
		# create directories for config files.
		echo "Creating directories...."
		mkdir -p "/usr/share/ecryptfs-loader"
		error $? "Failed to create application directory"
		
		# copy files
		copy_files
		result=$?
		if [ $result -ne 0 ] ; then
			remove_files
			error $result "Failed to install files!! Installation Aborted."
		fi

    # install mime type
		xdg-mime install --mode system /usr/share/ecryptfs-loader/ecryptfsloader-ecryptfs.xml
		result=$?
		if [ $result -ne 0 ] ; then
			remove_files
			error $result "Failed to install mime type"
		fi

		echo "Install Complete"
		;;

	uninstall)
		remove_files
		echo "Uninstall Complete"
		;;

	*)
	usage
	exit 1
esac


