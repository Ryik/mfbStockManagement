#!/bin/sh

#  MFBStockManagement.sh
#  MFBStockManagement
#
#  Created by Gabriel Morin on 26/10/2017.
#  Copyright © 2017 MFB. All rights reserved.

newVersion=$1

echo $newVersion
PROJECT_DIR="MFBStockManagement"
INFOPLIST_FILE="Info.plist"
buildPlist=${PROJECT_DIR}/${INFOPLIST_FILE}

rm -rf *.ipa

echo $buildPlist
#newVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$buildPlist" | /usr/bin/perl -pe 's/(\d+\.\d+\.)(\d+)/$1.($2+1)/eg'`

echo $newVersion;
/usr/libexec/PListBuddy -c "Set :CFBundleVersion $newVersion" "$buildPlist"



echo "****clean current build setting****"
xcodebuild clean -configuration Release


echo "***should named the application and version***"
targetA="MFBStockManagement"
version=$newVersion

echo "***create folder and find directory***"
distDir="build/Release-iPhoneos"
current_path="$PWD"

#DISTRO_ZIP="${targetA}${version}.ipa.zip"
#DISTRO_FOLDER=IPA
#rm -rf build ${DISTRO_FOLDER}
rm -rdf "$distDir"
#mkdir -p ${DISTRO_FOLDER}
mkdir "$distDir"
TARGET=targetA
APPLICATION_NAME="${targetA}"
DEVELOPER_NAME

echo "****build EasyDL_Demo app****"
xcodebuild -target "$targetA" CODE_SIGN_IDENTITY="iPhone Distribution: Metrologic Instruments Inc."


echo "****package current application**** ***default director***"
xcrun -sdk iphoneos PackageApplication -v "${current_path}/${distDir}/${APPLICATION_NAME}.app" -o "${current_path}/${APPLICATION_NAME}${version}.ipa"

#zip  ${DISTRO_ZIP} ${DISTRO_FOLDER}/*

#copy this build result zip to desktop iSledCommonESRelease folder.
#cp -pf ${DISTRO_ZIP} ~/Desktop/iSledCommonESRelease

#find ${DISTRO_FOLDER} -type d -name Build -print0 | xargs -0 rm -rdf
#find ${DISTRO_FOLDER} -type d -name build -print0 | xargs -0 rm -rdf

rm -rdf ${distDir}
rm -rf build
#rm -rdf ${DISTRO_FOLDER}

#remove current project zip file.
#rm -rdf ${DISTRO_ZIP}
