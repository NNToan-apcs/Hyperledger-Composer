#!/bin/bash
VERSION=0.0.5
NETWORK=toan-network
CHANNEL_NAME=abc
PEER_ADMIN_1=PeerAdmin@$NETWORK-org1
PEER_ADMIN_2=PeerAdmin@$NETWORK-org2
USER_1=alice
USER_2=bob
CONNECTION_1=../Hyperledger-Fabric/iot-network/connection/org1/toan-network-org1.json
CONNECTION_2=../Hyperledger-Fabric/iot-network/connection/org2/toan-network-org2.json
EPF=../Hyperledger-Fabric/iot-network/connection/endorsement-policy.json
DELAY=60 #sleep 1 min
TIMEOUT=6000 # 100 min timeout
composer network install --card $PEER_ADMIN_1 --archiveFile $NETWORK@$VERSION.bna
composer network install --card $PEER_ADMIN_2 --archiveFile $NETWORK@$VERSION.bna

composer identity request -c $PEER_ADMIN_1 -u admin -s adminpw -d $USER_1

composer identity request -c $PEER_ADMIN_2 -u admin -s adminpw -d $USER_2

#sleep $DELAY
EXPECTED_RESULT=$NETWORK
echo "===================== Starting network '$NETWORK' on channel '$CHANNEL_NAME'... ===================== "
rc=1
starttime=$(date +%s)

# continue to poll
# we either get a successful response, or reach TIMEOUT
while test "$(($(date +%s)-starttime))" -lt "$TIMEOUT" -a $rc -ne 0 || $rc -ne 2 
do
    sleep $DELAY
    echo "Attempting to Start network '$NETWORK' ...$(($(date +%s)-starttime)) secs"
    set -x
    composer network start -c $PEER_ADMIN_1 -n $NETWORK -V $VERSION -o endorsementPolicyFile=$EPF -A $USER_1 -C $USER_1/admin-pub.pem -A $USER_2 -C $USER_2/admin-pub.pem >&log.txt
    res=$?
    set +x
    test $res -eq 0 && VALUE=$(cat log.txt | awk '/The connection to the network was successfully tested/ {print $NF}')
    echo $res
    echo $VALUE
    test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
    test $res -eq 1 && VALUE=$(cat log.txt | awk '/status: 500, message: chaincode exists/ {print $NF}')
    echo $res
    echo $VALUE
    test "$VALUE" = "$EXPECTED_RESULT)" && let rc=2
done
echo
cat log.txt
if test $rc -eq 0 ; then
    echo "===================== Starting network '$NETWORK' on channel '$CHANNEL_NAME' is successful ===================== "    
fi

if test $rc -eq 2 ; then     
    echo "===================== Starting network '$NETWORK' on channel '$CHANNEL_NAME' is started ===================== "    
else
    echo "!!!!!!!!!!!!!!! Starting network '$NETWORK' on channel '$CHANNEL_NAME' is FAIL !!!!!!!!!!!!!!!!"
    echo "!!!!!!!!!!!!!!! Possible reasons: network is starting !!!!!!!!!!!!!!!!!!!!"
    exit 1
fi

composer card create -p $CONNECTION_1 -u $USER_1 -n $NETWORK -c $USER_1/admin-pub.pem -k $USER_1/admin-priv.pem
composer card delete -c $USER_1@$NETWORK
composer card import -f $USER_1@$NETWORK.card
composer network ping -c $USER_1@$NETWORK

composer card create -p $CONNECTION_2 -u $USER_2 -n $NETWORK -c $USER_2/admin-pub.pem -k $USER_2/admin-priv.pem
composer card delete -c $USER_2@$NETWORK
composer card import -f $USER_2@$NETWORK.card
composer network ping -c $USER_2@$NETWORK

