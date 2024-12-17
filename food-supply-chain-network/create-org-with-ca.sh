# Starting CA Server
docker-compose -f compose/h-compose-ca.yaml up -d

docker ps

# Register Organizations:
bash organizations/fabric-ca/registerEnrollOrg1.sh

bash organizations/fabric-ca/registerEnrollOrderer.sh

# Up the peers``:
# docker-compose -f compose/compose-with-couch.yaml up -d
docker-compose -f compose/compose-with-couch.yaml up -d


docker ps

# Creating Connection Profile
# bash ccp-generate.sh