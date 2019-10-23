#!/bin/bash

function hanoi(){
    local num=$1
    if [ "$num" -eq "1" ];then
        echo "Move:$2----->$4"
    else
        hanoi $((num-1)) $2 $4 $3
        echo "Move:$2----->$4"
        hanoi $((num-1)) $3 $2 $4
    fi
}

hanoi 4 A B C