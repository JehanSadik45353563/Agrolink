#!/bin/bash

source register-enroll-org.sh
source registerEnrollOrderer.sh

function makeDirs {
    mkdir -p "compose/"
    mkdir -p "organizations/"
    mkdir -p "compose/compose-ca/"
    mkdir -p "compose/compose-peers/"
}

NETWORK_NAME="food-supply-network"

declare -a orderers=(
    "orderer:OrdererMSP:7050:7053:9443"
)

declare -a peers=(
    # "couchdb0:4984:peer0:buyer:8051:8052:9444:BuyerMSP"
    "couchdb0:4984:peer0:buyer:8051:8052:9444:BuyerMSP"
    "couchdb1:4985:peer0:seller:9051:9052:9445:SellerMSP"
    "couchdb2:4986:peer0:gov:1051:1052:9446:GovMSP"
)

declare -a ca_orgs=(
    # "Buyer:buyer:8054:18054"
    "Buyer:buyer:8054:18054"
    "Seller:seller:9054:19054"
    "Gov:gov:1054:20054"
)

declare -a ca_orderer_orgs=(
    "Orderer:orderer:7054:17054"
)

function generate_ca_config {
    local CANAME=$1
    local ORGNAMEINSMALL=$2

    if [ "$CANAME" == "Orderer" ]; then
        sed -e "s/\${CANAME}/$CANAME/g" \
            fabric-ca-orderer-template.yaml
    else
        sed -e "s/\${CANAME}/$CANAME/g" \
            -e "s/\${ORGNAMEINSMALL}/$ORGNAMEINSMALL/g" \
            fabric-ca-template.yaml
    fi
}

function generate_compose_file {
    local ORGNAMEINSMALL=$1
    local PORT1=$2
    local PORT2=$3
    local NETWORK=$4

    if [ "$CANAME" == "Orderer" ]; then
        sed -e "s/\${ORGNAMEINSMALL}/$ORGNAMEINSMALL/g" \
            -e "s/\${PORT1}/$PORT1/g" \
            -e "s/\${PORT2}/$PORT2/g" \
            -e "s/\${NETWORK}/$NETWORK/g" \
            compose-ca-orderer-template.yaml
    else
        sed -e "s/\${ORGNAMEINSMALL}/$ORGNAMEINSMALL/g" \
            -e "s/\${PORT1}/$PORT1/g" \
            -e "s/\${PORT2}/$PORT2/g" \
            -e "s/\${NETWORK}/$NETWORK/g" \
            compose-ca-org-template.yaml
    fi
}

function create_ca_orderer {
    for org_info in "${ca_orderer_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        mkdir -p "organizations/fabric-ca/${ORGNAMEINSMALL}Org"

        generate_ca_config "$CANAME" "$ORGNAMEINSMALL" >"organizations/fabric-ca/${ORGNAMEINSMALL}Org/fabric-ca-server-config.yaml"

        generate_compose_file "$ORGNAMEINSMALL" "$PORT1" "$PORT2" "$NETWORK_NAME">"compose/compose-ca/compose-ca-${ORGNAMEINSMALL}.yaml"
    done
}

function create_ca_org {
    for org_info in "${ca_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        mkdir -p "organizations/fabric-ca/${ORGNAMEINSMALL}"
        generate_ca_config "$CANAME" "$ORGNAMEINSMALL" >"organizations/fabric-ca/${ORGNAMEINSMALL}/fabric-ca-server-config.yaml"
        generate_compose_file "$ORGNAMEINSMALL" "$PORT1" "$PORT2" "$NETWORK_NAME">"compose/compose-ca/compose-ca-${ORGNAMEINSMALL}.yaml"
    done
}

function ca_up {
    local command_string="docker compose"

    for org_info in "${ca_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        command_string+=" -f compose/compose-ca/compose-ca-${ORGNAMEINSMALL}.yaml"
    done

    for org_info in "${ca_orderer_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        command_string+=" -f compose/compose-ca/compose-ca-${ORGNAMEINSMALL}.yaml"
    done

    command_string+=" up -d"

    # Execute the generated command string
    eval "$command_string"
}

function down {
    local command_string="docker compose"

    for org_info in "${ca_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        command_string+=" -f compose/compose-ca/compose-ca-${ORGNAMEINSMALL}.yaml"
    done

    for org_info in "${ca_orderer_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        command_string+=" -f compose/compose-ca/compose-ca-${ORGNAMEINSMALL}.yaml"
    done

    command_string+=" down -v"

    eval "$command_string"

    command_string="docker compose"

    for peer_info in "${peers[@]}"; do
        IFS=':' read -r COUCHDB_NAME COUCHDB_PORT PEER_NAME PEER_ORG PEER_PORT1 PEER_PORT2 PEER_PORT3 PEER_MSP <<<"$peer_info"

        command_string+=" -f compose/compose-peers/compose-${PEER_NAME}-${PEER_ORG}.yaml"
    done

    for orderer_info in "${orderers[@]}"; do
        IFS=':' read -r ORDERER_NAME ORDERER_MSP ORDERER_PORT1 ORDERER_PORT2 ORDERER_PORT3  <<<"$orderer_info"

        command_string+=" -f compose/compose-peers/compose-${ORDERER_NAME}.yaml"
    done

    command_string+=" -f compose/compose-peers/compose-cli.yaml"

    command_string+=" down -v"

    eval "$command_string"
    

    # Execute the generated command string
    # eval "$command_string"
    # docker compose -f compose/compose-ca/compose-ca-buyer.yaml down -v --remove-orphans
    # docker compose -f compose/compose-ca/compose-ca-buyer.yaml -f compose/compose-ca/compose-ca-buyerbank.yaml -f compose/compose-ca/compose-ca-buyercp.yaml -f compose/compose-ca/compose-ca-middlebank.yaml -f compose/compose-ca/compose-ca-orderer.yaml -f compose/compose-ca/compose-ca-seller.yaml -f compose/compose-ca/compose-ca-sellerbank.yaml -f compose/compose-ca/compose-ca-sellercp.yaml down -v
}

function create_peers_orderers {
    for peer_info in "${peers[@]}"; do
        IFS=':' read -r COUCHDB_NAME COUCHDB_PORT PEER_NAME PEER_ORG PEER_PORT1 PEER_PORT2 PEER_PORT3 PEER_MSP <<<"$peer_info"

        sed -e "s/\${NETWORK_NAME}/$NETWORK_NAME/g" \
            -e "s/\${COUCHDB_NAME}/$COUCHDB_NAME/g" \
            -e "s/\${COUCHDB_PORT}/$COUCHDB_PORT/g" \
            -e "s/\${PEER_NAME}/$PEER_NAME/g" \
            -e "s/\${PEER_ORG}/$PEER_ORG/g" \
            -e "s/\${PEER_PORT1}/$PEER_PORT1/g" \
            -e "s/\${PEER_PORT2}/$PEER_PORT2/g" \
            -e "s/\${PEER_PORT3}/$PEER_PORT3/g" \
            -e "s/\${PEER_MSP}/$PEER_MSP/g" \
            compose-peer-org-template.yaml > "compose/compose-peers/compose-${PEER_NAME}-${PEER_ORG}.yaml"
    done

    for orderer_info in "${orderers[@]}"; do
        IFS=':' read -r ORDERER_NAME ORDERER_MSP ORDERER_PORT1 ORDERER_PORT2 ORDERER_PORT3  <<<"$orderer_info"

        sed -e "s/\${NETWORK_NAME}/$NETWORK_NAME/g" \
            -e "s/\${ORDERER_NAME}/$ORDERER_NAME/g" \
            -e "s/\${ORDERER_MSP}/$ORDERER_MSP/g" \
            -e "s/\${ORDERER_PORT1}/$ORDERER_PORT1/g" \
            -e "s/\${ORDERER_PORT2}/$ORDERER_PORT2/g" \
            -e "s/\${ORDERER_PORT3}/$ORDERER_PORT3/g" \
            compose-orderer-org-template.yaml > "compose/compose-peers/compose-${ORDERER_NAME}.yaml"
    done

    local TEXT_STRING=""
    for peer_info in "${peers[@]}"; do
        IFS=':' read -r COUCHDB_NAME COUCHDB_PORT PEER_NAME PEER_ORG PEER_PORT1 PEER_PORT2 PEER_PORT3 PEER_MSP <<<"$peer_info"
        
        TEXT_STRING+="- ${PEER_NAME}.${PEER_ORG}.example.com \n      "
    done

    sed -e "s/\${NETWORK_NAME}/$NETWORK_NAME/g" \
        -e "s/\${TEXT_STRING}/$TEXT_STRING/g" \
        compose-cli-template.yaml > "compose/compose-peers/compose-cli.yaml"
}

function peer_up {
    # docker compose -f compose/compose-with-couch.yaml up -d
    local command_string="docker compose"

    for peer_info in "${peers[@]}"; do
        IFS=':' read -r COUCHDB_NAME COUCHDB_PORT PEER_NAME PEER_ORG PEER_PORT1 PEER_PORT2 PEER_PORT3 PEER_MSP <<<"$peer_info"

        command_string+=" -f compose/compose-peers/compose-${PEER_NAME}-${PEER_ORG}.yaml"
    done

    for orderer_info in "${orderers[@]}"; do
        IFS=':' read -r ORDERER_NAME ORDERER_MSP ORDERER_PORT1 ORDERER_PORT2 ORDERER_PORT3  <<<"$orderer_info"

        command_string+=" -f compose/compose-peers/compose-${ORDERER_NAME}.yaml"
    done

    command_string+=" -f compose/compose-peers/compose-cli.yaml"

    command_string+=" up -d"

    # Execute the generated command string
    eval "$command_string"
}

function create_register_enroll_org {
    for org_info in "${ca_orgs[@]}"; do
        IFS=':' read -r CANAME ORGNAMEINSMALL PORT1 PORT2 <<<"$org_info"
        registerEnrollOrg $ORGNAMEINSMALL $PORT1 $PORT2
    done

    createOrderer

}

function cleanup {
    echo "Cleaning up..."

    rm -rf channel-artifacts
    sudo rm -rf organizations
    rm -rf compose
    echo "Cleanup completed."
}

function remove_docker_images {
    # docker images | grep "orderplaceandletterofcredit" | awk '{print $3}' | xargs docker rmi
    # docker images | grep "finalpapercontract" | awk '{print $3}' | xargs docker rmi
    docker images | grep "transactioncontract" | awk '{print $3}' | xargs -r docker rmi
}
