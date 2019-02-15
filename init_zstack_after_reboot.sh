#!/bin/bash
#Tony Lin 812158452@qq.com
#stop libvirtd ,zstack-kvmagent and ntpd service after reboot.

NODES=(NodeA NodeB NodeC NodeD)

# stop libvirtd and zstack-kvmagent service 
function stop_libvirtd() {
for node in ${NODES[*]}
do
  if [ "$node" == "NodeD" ]
  then
    continue #skip NodeD, because NodeD is not install libvirtd and zstack-kvmagent
  fi
  ssh $node 'systemctl stop libvirtd.service'
  ssh $node 'systemctl stop zstack-kvmagent.service'
done
}

# stop ntpd service
function stop_ntpd() {
for node in ${NODES[*]}
do
  if [ "$node" == "NodeA" ]
  then
    continue #skip NodeA, because the zstack manage can use default configurion to sync time
  fi
  ssh $node 'systemctl stop ntpd.service'
  ssh $node 'ntpdate ntp1.aliyun.com && hwclock -w'
done
}

case "$1" in
    libvirtd)
        stop_libvirtd
        ;;
    ntpd)
        stop_ntpd
        ;;
    *)
       echo " USAGE: $0 {libvirtd|ntpd}"
        ;;
esac
