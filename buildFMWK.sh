target_name=MakeFMWK
framework_name=CLBasicFramework

rootPath=$(cd "$(dirname "$0")"; pwd)

configuration=Release

build_Dir=${rootPath}/buildFMWK

for sdk in iphonesimulator iphoneos
do
    echo "制作framework ..."

    if [ $sdk == "iphoneos" ];then
        echo "sdk是真机"
        excu_name=dev
    else
        echo "sdk是模拟器"
        excu_name=sim
    fi

    xcodebuild -sdk $sdk  -configuration ${configuration} -target ${target_name} TARGET_BUILD_DIR=${build_Dir}

    if [ $? -eq 0 ]; then
        mv ${build_Dir}/${framework_name}.framework/${framework_name} ${build_Dir}/$excu_name
    else
        exit 2
    fi
done

lipo -create ${build_Dir}/dev ${build_Dir}/sim -o ${build_Dir}/${framework_name}
lipo -i ${build_Dir}/${framework_name}
mv ${build_Dir}/${framework_name} ${build_Dir}/${framework_name}.framework

if [ $? -eq 0 ]; then
    rm -rf ${build_Dir}/dev
    rm -rf ${build_Dir}/sim
fi