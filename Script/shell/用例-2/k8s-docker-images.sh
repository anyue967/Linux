#!/bin/bash
#k8s-docker-images

# 自己添加需要下载的镜像
images=(
    pause-amd64:3.0
    kube-proxy-amd64:v1.5.3 
    kube-scheduler-amd64:v1.5.3 
    kube-controller-manager-amd64:v1.5.3 
    kube-apiserver-amd64:v1.5.3 
    etcd-amd64:3.0.14-kubeadm 
    kube-discovery-amd64:1.0 
    
    kubedns-amd64:1.9 
    kube-dnsmasq-amd64:1.4 
    exechealthz-amd64:1.2 
    dnsmasq-metrics-amd64:1.0    
)

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName gcr.io/google_containers/$imageName
    docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done
