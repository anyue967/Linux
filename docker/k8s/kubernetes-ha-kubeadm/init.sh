#!/bin/bash

target=target
declare -A kvs=()   # 声明数组

# 替换核心函数
function replace_files() {
    local file=$1
    if [ -f $file ]; then
        echo "$file"
        for key in ${!kvs[@]}   #   
        do
            value=${kvs[$key]}  
            value=${value//\//\\\/} #
            sed -i "s/{{$key}}/${value}/g" $file
        done
        return 0
    fi
    if [ -d $file ]; then
        for f in `ls $file`
        do
            replace_files "${file}/${f}"
        done
    fi
    return 0
}

rm -rf $target
mkdir -p $target

cp -r configs $target
cp -r scripts $target
cp -r addons $target
cd $target      # 切进目标生成目录, 进行文件替换

echo "====替换变量列表===="
while read line
do
    if [ "${line:0:1}" == "#" -o "${line:0:1}" == "" ]
    then
        continue;
    fi
    key=${line/=*/}     # key=name 截取 = 之前全部字符
    value=${line#*=}    # value=IP截取 = 之后全部字符
    echo "$key=$value"       
    kvs["$key"]="$value"   # 
done < ../global-config.properties

echo -e "\n====替换脚本===="
replace_files scripts

echo -e "\n====替换配置文件===="
DIR=${kvs["MASTER_0_IP"]}
mkdir $DIR
cp -r ./configs/kubeadm-config.yaml $DIR
kvs["HOST_IP"]=$DIR
kvs["HOST_NAME"]=${kvs["MASTER_0_HOSTNAME"]}
replace_files $DIR

DIR=${kvs["MASTER_1_IP"]}
mkdir $DIR
cp -r ./configs/kubeadm-config.yaml $DIR
kvs["HOST_IP"]=$DIR
kvs["HOST_NAME"]=${kvs["MASTER_1_HOSTNAME"]}
replace_files $DIR

DIR=${kvs["MASTER_2_IP"]}
mkdir $DIR
cp -r ./configs/kubeadm-config.yaml $DIR
kvs["HOST_IP"]=$DIR
kvs["HOST_NAME"]=${kvs["MASTER_2_HOSTNAME"]}
replace_files $DIR
rm -rf ./configs/kubeadm-config.yaml

replace_files config
replace_files addons

echo "配置生成成功，位置: `pwd`"
