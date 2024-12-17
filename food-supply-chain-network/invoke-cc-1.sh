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

# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/doctor.example.com/peers/peer0.doctor.example.com/tls/ca.crt" \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/patient.example.com/peers/peer0.patient.example.com/tls/ca.crt" \
#     -c '{"function":"GetAllAppointments","Args":[]}'

# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/doctor.example.com/peers/peer0.doctor.example.com/tls/ca.crt" \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/patient.example.com/peers/peer0.patient.example.com/tls/ca.crt" \
#     -c '{"function":"ReadAppointmentByID","Args":["appointment0"]}'


# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/doctor.example.com/peers/peer0.doctor.example.com/tls/ca.crt" \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/patient.example.com/peers/peer0.patient.example.com/tls/ca.crt" \
#     -c '{"function":"ReadAppointmentByDoctorID","Args":["doctor 1"]}'


# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/doctor.example.com/peers/peer0.doctor.example.com/tls/ca.crt" \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/patient.example.com/peers/peer0.patient.example.com/tls/ca.crt" \
#     -c '{"function":"ReadAppointmentByPatientID","Args":["patient 1"]}'

# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/doctor.example.com/peers/peer0.doctor.example.com/tls/ca.crt" \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/patient.example.com/peers/peer0.patient.example.com/tls/ca.crt" \
#     -c '{"function":"ReadAppointmentByPatientID","Args":["patient 1swdw"]}'

# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/doctor.example.com/peers/peer0.doctor.example.com/tls/ca.crt" \
#     --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/crypto-config/peerOrganizations/patient.example.com/peers/peer0.patient.example.com/tls/ca.crt" \
#     -c '{"function":"ReadAppointmentByJSONQuery","Args":["{ \"patient_id\": \"patient 1\" }"]}'
    
# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
#     -c '{"function":"submitOrder","Args":["101", "CompanyA", "companya@gmail.com", "Product A", "200", "Letter of Credit", "Country A"]}'
    
# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
#     -c '{"function":"getOrder","Args":["101"]}'









peer chaincode invoke \
    -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
    -C ${CHANNEL_NAME} \
    -n ${CC_NAME} \
    --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
    -c '{"function":"InitLedger","Args":[]}'

# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
#     -c '{"function":"GetAllTransactions","Args":[]}'

# peer chaincode invoke \
#     -o localhost:7050 \
#     --ordererTLSHostnameOverride orderer.example.com \
#     --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#     -C ${CHANNEL_NAME} \
#     -n ${CC_NAME} \
#     --peerAddresses localhost:8051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/buyer.example.com/peers/peer0.buyer.example.com/tls/ca.crt" \
#     -c '{"function":"CreateTransaction","Args":["TRN000000002", "BD000000002", "Jehan Sadik", "BD000000001", "Minhaj Morshed Chowdhury", "[{\"ItemID\": \"ITEM000003\", \"ItemName\": \"Potato\", \"ItemType\": \"Lal Alu\", \"ItemQuantity\": 5, \"ItemUnitPrice\": 60, \"SubTotal\": 300}, {\"ItemID\": \"ITEM000002\", \"ItemName\": \"Onion\", \"ItemType\": \"Local Onion\", \"ItemQuantity\": 4, \"ItemUnitPrice\": 100, \"SubTotal\": 400}]", "14", "714", "Nagad", "paid"]}'