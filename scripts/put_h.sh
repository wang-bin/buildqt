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
time (
for qtmodule_h in *_h.7z
do
  qtmodule=${qtmodule_h/_h*/}
  echo "Putting headers into $qtmodule"
  7z x $qtmodule_h -o$qtmodule -y
done
)