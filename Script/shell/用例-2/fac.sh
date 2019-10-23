#!/bin/bash

function factorial() {
    local NUMBER=$1
    if [ $NUMBER -le 0 ]; then 
        RES=1
    else
        factorial $((NUMBER-1))
        TEMP=$RES
        NUMBER=$NUMBER
        RES=$((NUMBER*TEMP))
    fi
}
factorial $1
echo $RES