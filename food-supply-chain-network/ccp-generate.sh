#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
    	-e "s/\${ORGC}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGC}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

# ORG=organicfood
# ORGC=OrganicFood
# P0PORT=8051
# CAPORT=8054
# PEERPEM=organizations/peerOrganizations/organicfood.example.com/tlsca/tlsca.organicfood.example.com-cert.pem
# CAPEM=organizations/peerOrganizations/organicfood.example.com/ca/ca.organicfood.example.com-cert.pem

# echo "$(json_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/organicfood.example.com/connection-organicfood.json
# echo "$(yaml_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/organicfood.example.com/connection-organicfood.yaml

# Buyer
ORG=buyer
ORGC=Buyer
P0PORT=8051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/buyer.example.com/tlsca/tlsca.buyer.example.com-cert.pem
CAPEM=organizations/peerOrganizations/buyer.example.com/ca/ca.buyer.example.com-cert.pem

echo "$(json_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/buyer.example.com/connection-buyer.json
echo "$(yaml_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/buyer.example.com/connection-buyer.yaml


# Seller
ORG=seller
ORGC=Seller
P0PORT=9051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/seller.example.com/tlsca/tlsca.seller.example.com-cert.pem
CAPEM=organizations/peerOrganizations/seller.example.com/ca/ca.seller.example.com-cert.pem

echo "$(json_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/seller.example.com/connection-seller.json
echo "$(yaml_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/seller.example.com/connection-seller.yaml


# Gov
ORG=gov
ORGC=Gov
P0PORT=1051
CAPORT=1054
PEERPEM=organizations/peerOrganizations/gov.example.com/tlsca/tlsca.gov.example.com-cert.pem
CAPEM=organizations/peerOrganizations/gov.example.com/ca/ca.gov.example.com-cert.pem

echo "$(json_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gov.example.com/connection-gov.json
echo "$(yaml_ccp $ORG $ORGC $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gov.example.com/connection-gov.yaml
