#!/bin/bash

# Function to set environment variables for a peer
set_peer_env() {
    export FABRIC_CFG_PATH=${PWD}/compose/docker/peercfg
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_ADDRESS=$1
    export CORE_PEER_LOCALMSPID=$2
    export CORE_PEER_TLS_ROOTCERT_FILE=$3
    export CORE_PEER_MSPCONFIGPATH=$4
}

# Package the chaincode
export FABRIC_CFG_PATH=${PWD}/compose/docker/peercfg
export CC_PATH=../port-chaincodes/01-order-place-and-letter-of-credit/
export CC_NAME=orderplaceandletterofcredit
export CC_VERSION=1.0.1
export CHANNEL_NAME=foodsupplychannel
export SEQUENCE=1
export SIGNATUREPOLICY="OR('OrganicFoodMSP.peer')"

peer lifecycle chaincode package ${CC_NAME}.tar.gz --path "${CC_PATH}" --lang node --label ${CC_NAME}_${CC_VERSION}

# Install chaincode on Buyer's peer0
set_peer_env localhost:8051 "OrganicFoodMSP" "${PWD}/organizations/peerOrganizations/organicfood.example.com/peers/peer0.organicfood.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/organicfood.example.com/users/Admin@organicfood.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for Buyer peer0
export CC_PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid ${CC_NAME}.tar.gz)
peer lifecycle chaincode approveformyorg \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --channelID "${CHANNEL_NAME}" \
    --signature-policy "${SIGNATUREPOLICY}" \
    --name "${CC_NAME}" \
    --version "${CC_VERSION}" \
    --package-id "${CC_PACKAGE_ID}" \
    --sequence ${SEQUENCE} --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

# Checking approval readiness
peer lifecycle chaincode checkcommitreadiness --channelID "${CHANNEL_NAME}" --signature-policy "${SIGNATUREPOLICY}" --name ${CC_NAME} --version ${CC_VERSION} --sequence ${SEQUENCE} --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --output json

# Committing chaincode
peer lifecycle chaincode commit \
    -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
    --channelID "${CHANNEL_NAME}" \
    --signature-policy "${SIGNATUREPOLICY}" \
    --name "${CC_NAME}" --version "${CC_VERSION}" --sequence ${SEQUENCE} \
    --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
    --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/organicfood.example.com/peers/peer0.organicfood.example.com/tls/ca.crt" 
    
# Querying committed chaincode
peer lifecycle chaincode querycommitted --channelID "${CHANNEL_NAME}" --name ${CC_NAME}
