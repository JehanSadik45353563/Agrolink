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

export CC_NAME=transactioncontract
export CHANNEL_NAME=foodsupplychainchannel

set_peer_env localhost:8051 "BuyerMSP" "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/buyer.example.com/users/Admin@buyer.example.com/msp"



peer chaincode invoke \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
    -C ${CHANNEL_NAME} \
    -n ${CC_NAME} \
    --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
    -c '{"function":"InitLedger","Args":[]}'