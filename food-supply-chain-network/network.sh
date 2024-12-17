#!/bin/bash

# Function to set environment variables for a peer
set_peer_env() {
    export FABRIC_CFG_PATH=${PWD}/configtx/
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_ADDRESS=$1
    export CORE_PEER_LOCALMSPID=$2
    export CORE_PEER_TLS_ROOTCERT_FILE=$3
    export CORE_PEER_MSPCONFIGPATH=$4
}

# Function to join a peer to a channel
join_peer_to_channel() {
    set_peer_env $1 $2 $3 $4

    peer channel join -b ./channel-artifacts/$5.block
}

# Function to get channel info for a peer
get_channel_info() {
    set_peer_env $1 $2 $3 $4

    peer channel getinfo -c $5
}

# Create Genesis Block:
export FABRIC_CFG_PATH=${PWD}/configtx
cd configtx/
configtxgen -profile FoodSupplyChainChannel -outputBlock ../channel-artifacts/foodsupplychainchannel.block -channelID foodsupplychainchannel
cd ..

# Join the orderer to all channels:
# # Orderer
echo "Joining"
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

osnadmin channel join --channelID foodsupplychainchannel --config-block ./channel-artifacts/foodsupplychainchannel.block -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"



# Join peers to the channel:
# join_peer_to_channel localhost:8051 "OrganicFoodMSP" "${PWD}/organizations/peerOrganizations/organicfood.example.com/peers/peer0.organicfood.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/organicfood.example.com/users/Admin@organicfood.example.com/msp" foodsupplychannel

join_peer_to_channel localhost:8051 "BuyerMSP" "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/buyer.example.com/users/Admin@buyer.example.com/msp" foodsupplychainchannel

join_peer_to_channel localhost:9051 "SellerMSP" "${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/seller.example.com/users/Admin@seller.example.com/msp" foodsupplychainchannel

join_peer_to_channel localhost:1051 "GovMSP" "${PWD}/organizations/peerOrganizations/gov.example.com/peers/peer0.gov.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/gov.example.com/users/Admin@gov.example.com/msp" foodsupplychainchannel

# Peer Channel Info:
# get_channel_info localhost:8051 "OrganicFoodMSP" "${PWD}/organizations/peerOrganizations/organicfood.example.com/peers/peer0.organicfood.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/organicfood.example.com/users/Admin@organicfood.example.com/msp" foodsupplychannel

get_channel_info localhost:8051 "BuyerMSP" "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/buyer.example.com/users/Admin@buyer.example.com/msp" foodsupplychainchannel

get_channel_info localhost:9051 "SellerMSP" "${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/seller.example.com/users/Admin@seller.example.com/msp" foodsupplychainchannel

get_channel_info localhost:1051 "GovMSP" "${PWD}/organizations/peerOrganizations/gov.example.com/peers/peer0.gov.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/gov.example.com/users/Admin@gov.example.com/msp" foodsupplychainchannel
