#!/usr/bin/env bash
if [ $# -lt 1 ]; then
	echo "Usage: $0 version"
	exit 1
fi
version=$1
orig_dir=$(pwd)
work_dir=/tmp
patch_dir=$work_dir/node-v$version/deps/v8/
patch_file=$work_dir/node-v$version/deps/v8/SConstruct.patch
cd $work_dir
wget -O - http://nodejs.org/dist/v$version/node-v$version.tar.gz|tar xz
if [ $? -ne 0 ]; then
	echo "Something wrong fetching/decompressing node-v$version.tar.gz"
	exit 0
fi
echo "--- SConstruct	2013-09-30 16:52:48.000000000 -0400	
+++ ../../../node-v$version-custom/deps/v8/SConstruct	2013-09-30 16:52:48.000000000 -0400
@@ -80,7 +80,7 @@
   },
   'gcc': {
     'all': {
-      'CCFLAGS':      ['\$DIALECTFLAGS', '\$WARNINGFLAGS'],
+      'CCFLAGS':      ['\$DIALECTFLAGS', '\$WARNINGFLAGS', '-march=armv6'],
       'CXXFLAGS':     ['-fno-rtti', '-fno-exceptions'],
     },
     'visibility:hidden': {
@@ -159,12 +159,12 @@
       },
       'armeabi:softfp' : {
         'CPPDEFINES' : ['USE_EABI_HARDFLOAT=0'],
-        'vfp3:on': {
-          'CPPDEFINES' : ['CAN_USE_VFP_INSTRUCTIONS']
-        },
-        'simulator:none': {
-          'CCFLAGS':     ['-mfloat-abi=softfp'],
-        }
+#        'vfp3:on': {
+#          'CPPDEFINES' : ['CAN_USE_VFP_INSTRUCTIONS']
+#        },
+#        'simulator:none': {
+#          'CCFLAGS':     ['-mfloat-abi=softfp'],
+#        }
       },
       'armeabi:hard' : {
         'CPPDEFINES' : ['USE_EABI_HARDFLOAT=1'],
" > $patch_file
cd $patch_dir
patch -p0 < SConstruct.patch
cd ../..
./configure && make && sudo make install
cd $orig_dir
