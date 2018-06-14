#!/bin/bash
VERSION=0.0.5
NETWORK=toan-network
PEER_ADMIN_1=PeerAdmin@$NETWORK-org1
PEER_ADMIN_2=PeerAdmin@$NETWORK-org2
USER_1=alice
USER_2=bob
CONNECTION_1=~/Hyperledger/toan-fabric-network/iot-network/connection/org1/toan-network-org1.json
CONNECTION_2=~/Hyperledger/toan-fabric-network/iot-network/connection/org2/toan-network-org2.json
EPF=~/Hyperledger/toan-fabric-network/iot-network/connection/endorsement-policy.json

composer network install --card $PEER_ADMIN_1 --archiveFile $NETWORK@$VERSION.bna
composer network install --card $PEER_ADMIN_2 --archiveFile $NETWORK@$VERSION.bna

composer identity request -c $PEER_ADMIN_1 -u admin -s adminpw -d $USER_1

composer identity request -c $PEER_ADMIN_2 -u admin -s adminpw -d $USER_2

composer network start -c $PEER_ADMIN_1 -n $NETWORK -V $VERSION -o endorsementPolicyFile=$EPF -A $USER_1 -C $USER_1/admin-pub.pem -A $USER_2 -C $USER_2/admin-pub.pem

composer card create -p $CONNECTION_1 -u $USER_1 -n $NETWORK -c $USER_1/admin-pub.pem -k $USER_1/admin-priv.pem
composer card delete -c $USER_1@$NETWORK
composer card import -f $USER_1@$NETWORK.card
composer network ping -c $USER_1@$NETWORK

composer card create -p $CONNECTION_2 -u $USER_2 -n $NETWORK -c $USER_2/admin-pub.pem -k $USER_2/admin-priv.pem
composer card delete -c $USER_2@$NETWORK
composer card import -f $USER_2@$NETWORK.card
composer network ping -c $USER_2@$NETWORK