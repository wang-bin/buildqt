#!/bin/bash
#
# wbsecg1@gmail.com 2012-01-07
# get headers from in build dir from source dir
# get_h.sh must be in $QT_SRC_DIR/include
# put_h.sh must be in $QTDIR/include
# cd $QT_SRC_DIR/include; ./get_h.sh
# mv Qt*_h.7z $QTDIR/include
# cd $QTDIR/include
# ./put_h.sh
#
QT_MODULES=`find . -xtype d -maxdepth 1 |sed 's/\.\///g' |grep -v "\."`
time (
for qtmodule in $QT_MODULES
do
  echo "Getting headers for $qtmodule..."
  cd $qtmodule
  cat *.h |sed 's/#include \"\(.*\)\"/\1/g' >h.list
  [ -f h.7z ] && rm h.7z
  7z a h.7z @h.list
  rm h.list
  cd ..
  [ -f $qtmodule/h.7z ] && mv $qtmodule/h.7z ${qtmodule}_h.7z
done
)