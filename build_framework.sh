#!/bin/sh

configuration="Release"
DEV_FLAG=""
VER_FLAG=""

for i in "$@"
do
PFLAG=`echo $i|cut -b1-2`
PPARAM=`echo $i|cut -b3-`
if [ $PFLAG == "-b" ]
then
DEV_FLAG=$PPARAM
elif [ $PFLAG == "-v" ]
then
VER_FLAG=$PPARAM
fi
done

if [[ ${DEV_FLAG} == "debug" ]] || [[ ${DEV_FLAG} == "Debug" ]]
then
configuration="Debug"
else
configuration="Release"
fi

FMK_NAME="Tiercel"

INSTALL_DIR=$(pwd)/Products/${FMK_NAME}.framework

WORK_DIR=build

DEVICE_DIR=${WORK_DIR}/${configuration}-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WORK_DIR}/${configuration}-iphonesimulator/${FMK_NAME}.framework

TARGET_DEVICE="iphoneos"
TARGET_SIMULATOR="iphonesimulator"


# 修改编译时间和版本号
c_time=`date "+%Y-%m-%d %H:%M"`

build_time="Tiercel_BuildTime  @\"${c_time}\""
sed -i "" "s/Tiercel_BuildTime.*/${build_time}/g" ./Sources/Tiercel.h

build_version="Tiercel_Version    @\"${VER_FLAG}\""
sed -i "" "s/Tiercel_Version.*/${build_version}/g" ./Sources/Tiercel.h


xcodebuild clean \
-configuration ${configuration} \
-target ${FMK_NAME} \
-sdk ${TARGET_DEVICE} \
-UseModernBuildSystem=YES

xcodebuild clean \
-configuration ${configuration} \
-target ${FMK_NAME} \
-sdk ${TARGET_SIMULATOR} \
-UseModernBuildSystem=YES


xcodebuild build \
-configuration ${configuration} \
-target ${FMK_NAME} \
-sdk ${TARGET_SIMULATOR} -arch x86_64 \
-UseModernBuildSystem=YES \
 ONLY_ACTIVE_ARCH=NO \
 GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
 GCC_SYMBOLS_PRIVATE_EXTERN=YES \
 SYMROOT=build |xcpretty


xcodebuild build \
-configuration ${configuration} \
-target ${FMK_NAME} \
-sdk ${TARGET_DEVICE} -arch armv7 -arch arm64 \
-UseModernBuildSystem=YES \
 ONLY_ACTIVE_ARCH=NO \
 GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
 GCC_SYMBOLS_PRIVATE_EXTERN=YES \
 SYMROOT=build |xcpretty


if [ -d ${INSTALL_DIR} ]
then
rm -rf ${INSTALL_DIR}
fi
mkdir -p ${INSTALL_DIR}

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
cp -R "${SIMULATOR_DIR}/" "${INSTALL_DIR}/"

lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r ${WORK_DIR}

# 自动移动到 Demo SDK 目录
DST_DIR="Frameworks"
if [ ! -d $DST_DIR ]; then
mkdir -p "$DST_DIR"
fi
rm -rf ${DST_DIR}/${FMK_NAME}.framework
cp -af ${INSTALL_DIR} ${DST_DIR}

rm -r $(pwd)/Products

echo "***完成 Build ${FMK_NAME}.framework ${configuration} ****"
