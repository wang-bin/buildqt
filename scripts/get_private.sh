#!/bin/bash
#
# wbsecg1@gmail.com 2012-02-03
# get private headers from in build dir from source dir
# get_private.sh must be in $QT_SRC_DIR/include
# put_private.sh must be in $QTDIR/include
# cd $QT_SRC_DIR/include; ./get_private.sh
# mv Qt*_private.7z $QTDIR/include
# cd $QTDIR/include
# ./put_private.sh
#
QT_MODULES=`find . -xtype d -maxdepth 1 |sed 's/\.\///g' |grep -v "\."`
time (
if [ "x$1" = "xhere" ]; then
  for qtmodule in $QT_MODULES
  do
    echo "Getting private headers for $qtmodule... $PWD"
    cd $qtmodule
    if [ -d private ]; then
      [ -f private.7z ] && rm private.7z
      cd private
      7z a ../private.7z *
      cd ..
    fi
    cd ..
    [ -f $qtmodule/private.7z ] && mv $qtmodule/private.7z ${qtmodule}_private.7z
  done
  exit 0
fi

for qtmodule in $QT_MODULES
do
  echo "Getting private headers for $qtmodule..."
  cd $qtmodule
  pdir=`find . -type d |grep private`
  if [ "X$pdir" != "X" ]; then
	  cd $pdir
	  cat *.h |sed 's/#include \"\(.*\)\"/\1/g' >private.list
	  #rdir=`head -n 1 private.list |sed 's/\(.*src\).*/\1/'`
	  #echo "$rdir"
	  [ -f private.7z ] && rm private.7z
	  7z a private.7z @private.list
	  rm private.list
	  cd -
  fi
  cd ..
  [ -f $qtmodule/$pdir/private.7z ] && mv $qtmodule/$pdir/private.7z ${qtmodule}_private.7z
done
)