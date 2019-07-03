#!/bin/bash
MenTotal(){
    awk '/^MemTotal/{print $2}' /proc/meminfo
}
