# toan-network

Mobile devices

# Install
## Pre-requisites:
```
curl -O https://hyperledger.github.io/composer/latest/prereqs-ubuntu.sh

chmod u+x prereqs-ubuntu.sh

./prereqs-ubuntu.sh
```
## Development environment:

### CLI tools
```
npm install -g composer-cli
npm install -g composer-rest-server
npm install -g generator-hyperledger-composer
npm install -g yo
npm install -g grpc
npm install -g composer-playground
```
Uninstall commands
```
npm uninstall -g composer-cli
npm uninstall -g composer-rest-server
npm uninstall -g generator-hyperledger-composer
npm uninstall -g yo
npm uninstall -g grpc
npm uninstall -g composer-playground
```
### IDE
VScode : https://code.visualstudio.com/download
Extension : Hyperledger Composer
# Run
```
cd toan-network
```
## Install business network onto Hyperledger Fabric peer nodes for org1 and org2:
```
composer network install --card PeerAdmin@toan-network-org1 --archiveFile toan-network@0.0.5.bna
composer network install --card PeerAdmin@toan-network-org2 --archiveFile toan-network@0.0.5.bna
```
## Get Alice cert from org1 admin
```
composer identity request -c PeerAdmin@toan-network-org1 -u admin -s adminpw -d alice
```
## Get Bob cert from org2 admin
```
composer identity request -c PeerAdmin@toan-network-org2 -u admin -s adminpw -d bob
```
## Start the business network
```
composer network start -c PeerAdmin@toan-network-org1 -n toan-network -V 0.0.5 -o endorsementPolicyFile=../Hyperledger-Fabric/iot-network/connection/endorsement-policy.json -A alice -C alice/admin-pub.pem -A bob -C bob/admin-pub.pem
```
## Creating a business network card to access the business network as Org1 and Org2
```
composer card create -p ../Hyperledger-Fabric/iot-network/connection/org1/toan-network-org1.json -u alice -n toan-network -c alice/admin-pub.pem -k alice/admin-priv.pem
composer card delete -c alice@toan-network
composer card import -f alice@toan-network.card
composer network ping -c alice@toan-network

composer card create -p ../Hyperledger-Fabric/iot-network/connection/org2/toan-network-org2.json -u bob -n toan-network -c bob/admin-pub.pem -k bob/admin-priv.pem
composer card delete -c bob@toan-network
composer card import -f bob@toan-network.card
composer network ping -c bob@toan-network
```
## Start Rest Server
```
composer-rest-server -c alice@toan-network -n never -w true
```

composer archive create --sourceType dir --sourceName . -a toan-network@0.0.9.bna

composer network install --card PeerAdmin@toan-network-org1 --archiveFile toan-network@0.0.9.bna
composer network install --card PeerAdmin@toan-network-org2 --archiveFile toan-network@0.0.9.bna
composer network upgrade -c PeerAdmin@toan-network-org1 PeerAd\
min@toan-network-org2 -n toan-network -V 0.0.9
composer network ping -c alice@toan-network | grep Business