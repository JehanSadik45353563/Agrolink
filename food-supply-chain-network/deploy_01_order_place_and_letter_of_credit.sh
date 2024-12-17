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
export CHANNEL_NAME=portchannel
export SEQUENCE=1
export SIGNATUREPOLICY="OR('BuyerMSP.peer', 'BuyerBankMSP.peer', 'BuyerCPMSP.peer', 'MiddleBankMSP.peer', 'SellerMSP.peer', 'SellerBankMSP.peer', 'SellerCPMSP.peer')"

peer lifecycle chaincode package ${CC_NAME}.tar.gz --path "${CC_PATH}" --lang node --label ${CC_NAME}_${CC_VERSION}

# Install chaincode on Buyer's peer0
set_peer_env localhost:8051 "BuyerMSP" "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/buyer.example.com/users/Admin@buyer.example.com/msp"
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

# Install chaincode on BuyerBank's peer0
set_peer_env localhost:9051 "BuyerBankMSP" "${PWD}/organizations/peerOrganizations/buyerbank.example.com/peers/peer0.buyerbank.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/buyerbank.example.com/users/Admin@buyerbank.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for BuyerBank peer0
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

# Install chaincode on BuyerCP's peer0
set_peer_env localhost:1051 "BuyerCPMSP" "${PWD}/organizations/peerOrganizations/buyercp.example.com/peers/peer0.buyercp.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/buyercp.example.com/users/Admin@buyercp.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for BuyerCP peer0
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

# Install chaincode on MiddleBank's peer0
set_peer_env localhost:1151 "MiddleBankMSP" "${PWD}/organizations/peerOrganizations/middlebank.example.com/peers/peer0.middlebank.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/middlebank.example.com/users/Admin@middlebank.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for MiddleBank peer0
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

# Install chaincode on Seller's peer0
set_peer_env localhost:1251 "SellerMSP" "${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/seller.example.com/users/Admin@seller.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for Seller peer0
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

# Install chaincode on SellerBank's peer0
set_peer_env localhost:1351 "SellerBankMSP" "${PWD}/organizations/peerOrganizations/sellerbank.example.com/peers/peer0.sellerbank.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/sellerbank.example.com/users/Admin@sellerbank.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for SellerBank peer0
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

# Install chaincode on SellerCP's peer0
set_peer_env localhost:1451 "SellerCPMSP" "${PWD}/organizations/peerOrganizations/sellercp.example.com/peers/peer0.sellercp.example.com/tls/ca.crt" "${PWD}/organizations/peerOrganizations/sellercp.example.com/users/Admin@sellercp.example.com/msp"
peer lifecycle chaincode install ${CC_NAME}.tar.gz
peer lifecycle chaincode queryinstalled

# Approving chaincode for SellerCP peer0
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
    --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
    --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyerbank.example.com/peers/peer0.buyerbank.example.com/tls/ca.crt" \
    --peerAddresses localhost:1051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyercp.example.com/peers/peer0.buyercp.example.com/tls/ca.crt" \
    --peerAddresses localhost:1151 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/middlebank.example.com/peers/peer0.middlebank.example.com/tls/ca.crt" \
    --peerAddresses localhost:1251 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/seller.example.com/peers/peer0.seller.example.com/tls/ca.crt" \
    --peerAddresses localhost:1351 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/sellerbank.example.com/peers/peer0.sellerbank.example.com/tls/ca.crt" \
    --peerAddresses localhost:1451 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/sellercp.example.com/peers/peer0.sellercp.example.com/tls/ca.crt"

# Querying committed chaincode
peer lifecycle chaincode querycommitted --channelID "${CHANNEL_NAME}" --name ${CC_NAME}
