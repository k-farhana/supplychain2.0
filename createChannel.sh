export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/supplychain.com/orderers/orderer.supplychain.com/msp/tlscacerts/tlsca.supplychain.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.supplier.com/peers/peer0.org1.supplier.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.manufacturer.com/peers/peer0.org2.manufacturer.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.distributor.com/peers/peer0.org3.distributor.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNELA_NAME=channela
export CHANNELB_NAME=channelb

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.supplier.com/users/Admin@org1.supplier.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer0Org2(){
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.manufacturer.com/users/Admin@org2.manufacturer.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer0Org3(){
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.distributor.com/users/Admin@org3.distributor.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
    
}

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Org1
    
    peer channel create -o localhost:7050 -c $CHANNELA_NAME \
    --ordererTLSHostnameOverride orderer.supplychain.com \
    -f ./artifacts/channel/${CHANNELA_NAME}.tx --outputBlock ./channel-artifacts/${CHANNELA_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    echo 'channel a created, creating channel b'
    
    setGlobalsForPeer0Org2
    peer channel create -o localhost:7050 -c $CHANNELB_NAME \
    --ordererTLSHostnameOverride orderer.supplychain.com \
    -f ./artifacts/channel/${CHANNELB_NAME}.tx --outputBlock ./channel-artifacts/${CHANNELB_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    echo 'channel b created'
}

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-org1/*
    rm -rf ./api-2.0/org1-wallet/*
    rm -rf ./api-2.0/org2-wallet/*
}


joinChannel(){
    setGlobalsForPeer0Org1
    peer channel join -b ./channel-artifacts/$CHANNELA_NAME.block
    peer channel join -b ./channel-artifacts/$CHANNELB_NAME.block
    
    
    setGlobalsForPeer0Org2
    peer channel join -b ./channel-artifacts/$CHANNELA_NAME.block
    peer channel join -b ./channel-artifacts/$CHANNELB_NAME.block
    
    setGlobalsForPeer0Org3
    peer channel join -b ./channel-artifacts/$CHANNELA_NAME.block
    peer channel join -b ./channel-artifacts/$CHANNELB_NAME.block
    
}

updateAnchorPeers(){
    setGlobalsForPeer0Org1
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.supplychain.com -c $CHANNELA_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.supplychain.com -c $CHANNELB_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0Org2
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.supplychain.com -c $CHANNELA_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchorsA.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.supplychain.com -c $CHANNELB_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchorsB.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0Org3
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.supplychain.com -c $CHANNELA_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.supplychain.com -c $CHANNELB_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

echo 'removing old crypto'
removeOldCrypto

echo 'creating channel'

createChannel

echo 'joining channel'
joinChannel

echo 'updating anchor peer'
updateAnchorPeers