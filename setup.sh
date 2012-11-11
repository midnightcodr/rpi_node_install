#!/usr/bin/env bash
orig_dir=$(pwd)
work_dir=/tmp
patch_dir=$work_dir/node-v0.8.14/deps/v8/
patch_file=$work_dir/node-v0.8.14/deps/v8/SConstruct.patch
cd $work_dir
wget -O - http://nodejs.org/dist/v0.8.14/node-v0.8.14.tar.gz|tar xz
echo "--- SConstruct	2012-10-25 16:49:32.000000000 -0400
+++ SConstruct.modified	2012-11-11 12:33:00.136775230 -0500
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
./configure && make && make install
cd $orig_dir
