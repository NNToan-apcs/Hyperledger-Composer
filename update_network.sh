#!/bin/bash
VERSION=0.0.13
NETWORK=toan-network
DELAY=60 #sleep 1 min
TIMEOUT=6000 # 100 min timeout

while getopts "h?v:n:" opt; do
  case "$opt" in
    h|\?)
      echo "Please use this following format:"
      echo "./script.sh -c <ChannelName> -n <NetworkName> -v <NetworkVersion>"
      echo "Default ChannelName: mychannel"
      echo "Default NetworkName: toan-network"
      echo "Default NetworkVersion: 0.0.1"
      exit 0
    ;;
    v)  VERSION=$OPTARG
    ;;
    n)  NETWORK=$OPTARG
    ;;
  esac
done


composer archive create --sourceType dir --sourceName . -a $NETWORK@$VERSION.bna 

composer network install --card PeerAdmin@$NETWORK-org1 --archiveFile $NETWORK@$VERSION.bna
composer network install --card PeerAdmin@$NETWORK-org2 --archiveFile $NETWORK@$VERSION.bna

EXPECTED_RESULT=$VERSION
echo "===================== Updating network '$NETWORK' on channel '$CHANNEL_NAME'... ===================== "
rc=1
starttime=$(date +%s)

while test "$(($(date +%s)-starttime))" -lt "$TIMEOUT" -a $rc -ne 0
do
    sleep $DELAY
    echo "Attempting to Start network '$NETWORK' in $(($(date +%s)-starttime)) secs ... "
    set -x
    composer network upgrade -c PeerAdmin@$NETWORK-org1 PeerAdmin@$NETWORK-org2 -n $NETWORK -V $VERSION 
    res=$?
    set +x
    composer network ping -c alice@$NETWORK | grep Business>&update_log.txt
    test $res -eq 1 && VALUE=$(cat update_log.txt | awk '/Business network version:/ {print $NF}')
    test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
done
echo
cat update_log.txt
if test $rc -eq 0 ; then
    echo "===================== Updating network '$NETWORK' on PeerAdmins: PeerAdmin@'$NETWORK'-org1 and PeerAdmin@'$NETWORK'-org2 is successful ===================== "    
else
    echo "!!!!!!!!!!!!!!! Updating network '$NETWORK' on PeerAdmins: PeerAdmin@'$NETWORK'-org1 and PeerAdmin@'$NETWORK'-org2 is FAIL !!!!!!!!!!!!!!!!"
    echo "!!!!!!!!!!!!!!! Possible reasons: Timeout !!!!!!!!!!!!!!!!!!!!"
    exit 1
fi


