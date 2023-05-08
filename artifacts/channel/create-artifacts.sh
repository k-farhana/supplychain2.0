
# Delete existing artifacts
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNELA_NAME="channela"
CHANNELB_NAME="channelb"

echo $CHANNEL_NAMEA
echo $CHANNEL_NAMEB

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile Channela -configPath . -outputCreateChannelTx ./$CHANNELA_NAME.tx -channelID $CHANNELA_NAME
configtxgen -profile Channelb -configPath . -outputCreateChannelTx ./$CHANNELB_NAME.tx -channelID $CHANNELB_NAME

echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile Channela -configPath . -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $CHANNELA_NAME -asOrg Org1MSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile Channela -configPath . -outputAnchorPeersUpdate ./Org2MSPanchorsA.tx -channelID $CHANNELA_NAME -asOrg Org2MSP
configtxgen -profile Channelb -configPath . -outputAnchorPeersUpdate ./Org2MSPanchorsB.tx -channelID $CHANNELB_NAME -asOrg Org2MSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
configtxgen -profile Channelb -configPath . -outputAnchorPeersUpdate ./Org3MSPanchors.tx -channelID $CHANNELB_NAME -asOrg Org3MSP
