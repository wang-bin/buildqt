#!/bin/bash
#
# wbsecg1@gmail.com 2011-12-18
# get private headers from in build dir from source dir
# get_private.sh must be in $QT_SRC_DIR/include
# put_private.sh must be in $QTDIR/include
# cd $QT_SRC_DIR/include; ./get_private.sh
# mv Qt*_private.7z $QTDIR/include
# cd $QTDIR/include
# ./put_private.sh
#
time (
for qtmodule_p in *_private.7z
do
  qtmodule=${qtmodule_p/_p*/}
  echo "Putting private headers into $qtmodule"
  mkdir -p $qtmodule/private
  7z x $qtmodule_p -o$qtmodule/private -y
done
)