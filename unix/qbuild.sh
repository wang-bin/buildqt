#!/bin/bash

#check bash version
#Requirement: accessibility needs pkg-config libatspi2.0-dev
help()
{
#Copyright
__cecho blue "setqt key value"
__cecho blue "setqt"
__cecho blue "buildqt"
__cecho blue "packqt"

}

#echo $PWD
CFG=$PWD/.cfg.old
[ -f $CFG ] && . $CFG
#vars is a var not used by configure
declare -A vars
vars["configure"]=${configure:-./configure}
vars["version"]=${version:-4.8.3}
vars["sdkdir"]=${sdkdir:-/opt/QtSDK}
vars["installdir"]=
vars[mkspec]=${mkspec:-linux-g++} #TODO: install dir depends mkspec or host?
vars[host]=${host:-linux-g++}

#opts contains variables and values to be used in configure
#see configure help message
declare -A opts

setqt() #[key=val]. no params means to run configure
{
	if [ $# -eq 0 ]; then
		__get_version ${vars[configure]}
		__init_opts
		echo "configure=${vars[configure]}" >$CFG
		echo "version=${vars[version]}" >>$CFG
		echo "sdkdir=${vars[sdkdir]}" >>$CFG
		echo "mkspec=${vars[mkspec]}" >>$CFG
		echo "host=${vars[host]}" >>$CFG

		echo ${vars[configure]} ${opts[@]}
		time ${vars[configure]} ${opts[@]}  << EOF
yes
EOF
	else
		#eval ${vars[$val]}=$val  #equals to: declare ${vars[$val]}=$val
		vars[$1]=$2
	fi
}


buildqt() #[-log]
{
	
	local cpu_cores=`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`
	local jobs=$(($cpu_cores * 2))
	if [ "$1" == "-log" ]; then
		log_opt=" 2>&1 |tee buildqt.log"
	fi
	eval time make -j$jobs $log_opt
}

installqt()
{
	local cpu_cores=`cat /proc/cpuinfo |grep 'cpu cores' |wc -l`
	local jobs=$(($cpu_cores * 2))
	time make install -j$jobs
}

packqt()
{
#install dir
	package=/tmp/qt${QT__VERSION_MAJOR}${QT__VERSION_MINOR}${QT__VERSION_PATCH}-${vars[mkspec]}_`date +%Y%m%d`.tar.xz
	time tar --use=xz -cvf $package ${vars[installdir]}
	du -h $package
}


###internal use functions###
__cecho() {
	while [[ $# > 1 ]]; do
		case $1 in
			red)	echo -n "$(tput setaf 1)";;
			green)	echo -n "$(tput setaf 2)";;
			blue)	echo -n "$(tput setaf 3)";;
			purple)	echo -n "$(tput setaf 4)";;
			cyan)	echo -n "$(tput setaf 5)";;
			grey)	echo -n "$(tput setaf 6)";;
			white)	echo -n "$(tput setaf 7)";;
			bold)	echo -n "$(tput bold)";;
			*) 	break;;
		esac
		shift
	done
	echo "$*$(tput sgr0)"
}

__get_version() #configure path
{
	src_dir=$(dirname $1)
	qglobal_h=$src_dir/src/corelib/global/qglobal.h

	QT__VERSION=`grep QT_VERSION_STR $qglobal_h |grep "#define" |sed 's/.*\"\(.*\)\".*/\1/'`
	vars["version"]=$QT__VERSION
	QT__VERSION_MAJOR=`echo $QT__VERSION |cut -d. -f1`
	QT__VERSION_MINOR=`echo $QT__VERSION |cut -d. -f2`
	QT__VERSION_PATCH=`echo $QT__VERSION |cut -d. -f3`
}


__init_opts()
{
	test -n "${vars[xplatform]}" && opts["cross"]="-xplatform ${vars[xplatform]}" && vars[mkspec]=${vars[xplatform]}
	if [ -n "`echo ${vars[mkspec]} |grep -i arm`" -a -n "${vars[installdir]}" ]; then
		vars[installdir]=${vars[sdkdir]}/Embedded/${vars[version]}/${vars[mkspec]}
	else
		vars[installdir]=${vars[sdkdir]}/Desktop/Qt/${vars[version]}/${vars[mkspec]}
	fi
	opts["install"]="-prefix ${vars[installdir]}"
	opts["generic"]="-developer-build -opensource -release -shared  -rpath -fast -pch -optimized-qmake -continue -javascript-jit -no-separate-debug-info"
	opts["plugin"]="-qt-sql-sqlit -qt-libpng -qt-zlib"
	opts["part"]="  -nomake demos -nomake tests -nomake examples"
	test -n "`echo ${vars[mkspec]} |grep -i linux`" &&  opts["linux"]="-dbus"
	test -n "${vars[x11]}" && opts["x11"]= #default x11 opts
	opts[qws]=
	#for 4.7
	test -n "`echo ${vars[mkspec]} |grep -i qws`" && opts["qws"]="-embedded armv6" # -qt-mouse-pc -qt-mouse-linuxinput -qt-mouse-linuxtp -qt-gfx-transformed -qt-gfx-linuxfb -qt-kbd-linuxinput"
	test -n "`echo ${vars[mkspec]} |grep -i ios`" && opts["ios"]="-qpa -arch armv7 -no-neon -little-endian -qconfig ios -opengl -openssl-linked" \
	&& opts["qws"]="" #"-no-gfx-linuxfb -no-kbd-tty -no-mouse-pc -no-mouse-linuxtp  -no-gfx-multiscreen -no-phonon-backend -no-accessibility"
	test -n "${vars[arch]}" && opts["arch"]="-arch ${vars[arch]}"
	if [ $QT__VERSION_MAJOR -eq 4 ]; then
		opts["plugin"]="${opts[plugin]} -qt-libtiff -qt-libmng"
		opts["generic"]="${opts[generic]}  -largefile -stl"
		opts["part"]="${opts[part]} -declarative -no-qt3support -script -scripttools -svg -multimedia -phonon -no-declarative-debug"
		opts["linux"]="${opts[linux]}  -freetype  -opengl"
		if [ $QT__VERSION_MINOR -ge 8 ]; then
			opts["generic"]="${opts[generic]} " #-silent
		else
			opts["plugin"]="${opts[plugin]}  -qt-gif"
		fi
	elif [ $QT__VERSION_MAJOR -eq 5 ]; then
		 opts["generic"]="${opts[generic]} -silent -accessibility -largefile" #-c++11 
		 test -n "`echo ${vars[mkspec]} |grep -i linux`" && opts["linux"]="${opts[linux]} -opengl -qpa xcb" #-qt-freetype"
	
	fi
	test -n "${vars[host]}" && opts[host]="-platform ${vars[host]}"
}


###begin###

help




