#!/bin/bash

array=( "$@" )
arraylength=${#array[@]}
orgname=${array[0]}
noofpeers=${array[1]}

mkdir -p $orgname

nameofnetwork=$(python operations.py getNetworkName)

echo -n '#!/bin/bash
sed -i "s/#neworgcryptoconfig/- Name: '$orgname'\n  Domain: '$orgname'.'$nameofnetwork'.com\n  EnableNodeOUs: true\n  Template:\n    Count: '$noofpeers'\n  Users:\n    Count: 10\n#neworgcryptoconfig/g" crypto-config.yaml'> tempscript.sh

chmod +x tempscript.sh
./tempscript.sh
rm tempscript.sh

############################## creating the keys for new peer   #############################################
../bin/cryptogen extend --config=./crypto-config.yaml

############################## adding the new org in consortium in configtx.yaml file   #############################################
 sed -i "s/#neworgconsortium/                    - *$orgname\n#neworgconsortium/" configtx.yaml

########################## updateing new org details (orgname and noofpeers) in ./network-configuration/orgstructure.json #########################################

python operations.py updateOrgCount nooforgs

########################## updateing new org details (orgname and noofpeers) in ./network-configuration/orgstructure.json #########################################

python operations.py addDetail "./network-configuration/orgstructure.json" {\"$orgname'" : "'$noofpeers\"' }'

########################## updateing new org cli details (orgname and cliname)  in ./network-configuration/cliname.json #########################################

python operations.py addDetail "./network-configuration/cliname.json" {\"$orgname'" : "'$orgname'cli" }'


CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/${array[0]}.$nameofnetwork.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"

########################## creating the docker-compose-e2e.yaml file for new org #########################################

echo -e "version: '2'

volumes:" >docker-compose-e2e-${array[0]}.yaml

for (( j=0; j<${array[1]}; j++ ));
do
    echo -e "  peer"$j"."${array[0]}"."$nameofnetwork".com:" >>docker-compose-e2e-${array[0]}.yaml
done

input1=$(cat ./network-configuration/portca.txt)
varport3=$(($input1+1))

caport=$(python operations.py getCaPort org1)
echo -e "networks:
  byfn:
services:
  ca"${array[0]}":
    image: hyperledger/fabric-ca:latest
    environment:
    - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
    - FABRIC_CA_SERVER_CA_NAME=ca-"${array[0]}"
    - FABRIC_CA_SERVER_TLS_ENABLED=true
    - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server-config/ca."${array[0]}"."$nameofnetwork".com-cert.pem
    - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server-config/"$PRIV_KEY"     
    ports:
    - "$varport3":"$caport"
    command: sh -c 'fabric-ca-server start --ca.certfile /etc/hyperledger/fabric-ca-server-config/ca."${array[0]}"."$nameofnetwork".com-cert.pem --ca.keyfile /etc/hyperledger/fabric-ca-server-config/"$PRIV_KEY" -b admin:adminpw -d'
    volumes:
    - ./crypto-config/peerOrganizations/"${array[0]}"."$nameofnetwork".com/ca/:/etc/hyperledger/fabric-ca-server-config
    container_name: ca_peer"${array[0]}"
    networks:
    - byfn" >>docker-compose-e2e-${array[0]}.yaml


echo $varport3 >./network-configuration/portca.txt

########################## updateing new org details (orgname and ports of ca) in orgsports.json #########################################

python operations.py addPortDetail caports '{"orgId":"'${array[0]}'", "port" :"'$varport3'"}'

str="{ \"orgId\" : \"${array[0]}\", \"peer\" : ["

########################## appending peers details in docker-compose-e2e.yaml file for new org #########################################

for (( j=0; j<${array[1]}; j++ ));
do
    input=$(cat ./network-configuration/portpeer.txt)
    varport1=$(($input+1))
    varport2=$(($input+2))
    if [ $j -ne 0 ]; then 
     str=$str", "
    fi
    if [ $j -eq 0 ]; then
    echo -e "  peer"$j"."${array[0]}"."$nameofnetwork".com:
    container_name: peer"$j"."${array[0]}"."$nameofnetwork".com
    extends:
      file: base/peer-base.yaml
      service: peer-base
    environment:
     - CORE_PEER_ID=peer"$j"."${array[0]}"."$nameofnetwork".com
     - CORE_PEER_LISTENADDRESS=0.0.0.0:"$varport1"
     - CORE_PEER_ADDRESS=peer"$j"."${array[0]}"."$nameofnetwork".com:"$varport1"
     - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer"$j"."${array[0]}"."$nameofnetwork".com:"$varport1"
     - CORE_PEER_GOSSIP_BOOTSTRAP=peer"$j"."${array[0]}"."$nameofnetwork".com:"$varport1"
     - CORE_PEER_LOCALMSPID="${array[0]}"MSP
    volumes:
        - /var/run/:/host/var/run/
        - ./crypto-config/peerOrganizations/"${array[0]}"."$nameofnetwork".com/peers/peer"$j"."${array[0]}"."$nameofnetwork".com/msp:/etc/hyperledger/fabric/msp
        - ./crypto-config/peerOrganizations/"${array[0]}"."$nameofnetwork".com/peers/peer"$j"."${array[0]}"."$nameofnetwork".com/tls:/etc/hyperledger/fabric/tls
        - peer"$j"."${array[0]}"."$nameofnetwork".com:/var/hyperledger/production
    ports:
    - $varport1:$varport1
    - $varport2:$varport2
    networks:
    - byfn" >> docker-compose-e2e-${array[0]}.yaml

        echo -e '#/bin/bash
        sed -i "s/#newanchorpeer/    - \&'${array[0]}'\\n        # DefaultOrg defines the organization which is used in the sampleconfig\\n        # of the fabric.git development environment\\n        Name: '${array[0]}'MSP\\n        # ID to load the MSP definition as\\n        ID: '${array[0]}'MSP\\n        MSPDir: crypto-config\/peerOrganizations\/'${array[0]}'.'$nameofnetwork'.com\/msp\\n        AnchorPeers:\\n            # AnchorPeers defines the location of peers which can be used\\n            # for cross org gossip communication.  Note, this value is only\\n            # encoded in the genesis block in the Application section context\\n            - Host: peer'$j'.'${array[0]}'.'$nameofnetwork'.com\\n              Port: '$varport1'\\n#newanchorpeer/g" configtx.yaml' > tempfile.sh
        
        if [ ${array[1]} -eq 1 ]; then
           echo -e 'sed -i "s/#neworg/elif [ \$ORG == \"'${array[0]}'\" ] ; then\\n          set -x\\n          CORE_PEER_LOCALMSPID=\"'${array[0]}'MSP\"\\n          CORE_PEER_TLS_ROOTCERT_FILE=\/opt\/gopath\/src\/github.com\/hyperledger\/fabric\/peer\/crypto\/peerOrganizations\/'${array[0]}'.'$nameofnetwork'.com\/peers\/peer'$j'.'${array[0]}'.'$nameofnetwork'.com\/tls\/ca.crt\\n          CORE_PEER_MSPCONFIGPATH=\/opt\/gopath\/src\/github.com\/hyperledger\/fabric\/peer\/crypto\/peerOrganizations\/'${array[0]}'.'$nameofnetwork'.com\/users\/Admin@'${array[0]}'.'$nameofnetwork'.com\/msp\\n          set +x\\n          if [ \$PEER -eq '$j' ]; then\\n            set -x\\n            CORE_PEER_ADDRESS=peer'$j'.'${array[0]}'.'$nameofnetwork'.com:'$varport1'\\n            set +x\\n#newpeer'${array[0]}'\\n          fi/g" ./scripts/utils.sh' >>tempfile.sh
        else
           echo -e 'sed -i "s/#neworg/elif [ \$ORG == \"'${array[0]}'\" ] ; then\\n          set -x\\n          CORE_PEER_LOCALMSPID=\"'${array[0]}'MSP\"\\n          CORE_PEER_TLS_ROOTCERT_FILE=\/opt\/gopath\/src\/github.com\/hyperledger\/fabric\/peer\/crypto\/peerOrganizations\/'${array[0]}'.'$nameofnetwork'.com\/peers\/peer'$j'.'${array[0]}'.'$nameofnetwork'.com\/tls\/ca.crt\\n          CORE_PEER_MSPCONFIGPATH=\/opt\/gopath\/src\/github.com\/hyperledger\/fabric\/peer\/crypto\/peerOrganizations\/'${array[0]}'.'$nameofnetwork'.com\/users\/Admin@'${array[0]}'.'$nameofnetwork'.com\/msp\\n          set +x\\n          if [ \$PEER -eq '$j' ]; then\\n            set -x\\n            CORE_PEER_ADDRESS=peer'$j'.'${array[0]}'.'$nameofnetwork'.com:'$varport1'\\n            set +x\\n#newpeer'${array[0]}'/g" ./scripts/utils.sh' >>tempfile.sh
        fi

        str=$str"{ \"peerName\" : \"peer$j\" , \"port\" : \"$varport1\" }"
        port1=$varport1
        port2=$varport2
        firstorg=${array[$i-1]}
        echo $varport2 >./network-configuration/portpeer.txt
     else
    echo -e '  peer'$j'.'${array[0]}'.'$nameofnetwork'.com:
    container_name: peer'$j'.'${array[0]}'.'$nameofnetwork'.com
    extends:
      file: base/peer-base.yaml
      service: peer-base
    environment:
     - CORE_PEER_ID=peer'$j'.'${array[0]}'.'$nameofnetwork'.com
     - CORE_PEER_LISTENADDRESS=0.0.0.0:'$port1'           
     - CORE_PEER_ADDRESS=peer'$j'.'${array[0]}'.'$nameofnetwork'.com:'$port1'
     - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.'${array[0]}'.'$nameofnetwork'.com:'$port1'
     - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer'$j'.'${array[0]}'.'$nameofnetwork'.com:'$port1'
     - CORE_PEER_LOCALMSPID='${array[0]}'MSP
    volumes:
        - /var/run/:/host/var/run/
        - ./crypto-config/peerOrganizations/'${array[0]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[0]}'.'$nameofnetwork'.com/msp:/etc/hyperledger/fabric/msp
        - ./crypto-config/peerOrganizations/'${array[0]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[0]}'.'$nameofnetwork'.com/tls:/etc/hyperledger/fabric/tls
        - peer'$j'.'${array[0]}'.'$nameofnetwork'.com:/var/hyperledger/production
    ports:
    - '$varport1':'$port1'
    - '$varport2':'$port2'
    networks:
    - byfn'>> docker-compose-e2e-${array[0]}.yaml
      
      if [ $j -eq $((${array[1]}-1)) ]; then 
       echo -e 'sed -i "s/#newpeer'${array[0]}'/          elif [ \$PEER -eq '$j' ]; then\\n            set -x\\n            CORE_PEER_ADDRESS=peer'$j'.'${array[0]}'.'$nameofnetwork'.com:'$port1'\\n            set +x\\n#newpeer'${array[0]}'\\n          fi\\n#neworg/g" ./scripts/utils.sh'  >> tempfile.sh
      else
       echo -e 'sed -i "s/#newpeer'${array[0]}'/          elif [ \$PEER -eq '$j' ]; then\\n            set -x\\n            CORE_PEER_ADDRESS=peer'$j'.'${array[0]}'.'$nameofnetwork'.com:'$port1'\\n            set +x\\n#newpeer'${array[0]}'/g" ./scripts/utils.sh'  >> tempfile.sh
      fi
      
      str=$str"{ \"peerName\" : \"peer$j\" , \"port\" : \"$varport1\" }"

      echo $varport2 >./network-configuration/portpeer.txt
      fi
done

str=$str"]}"

echo -e "########################## updateing new org details (orgname and ports of peers) in orgsports.json #########################################
python operations.py addPortDetail org '"$str"'">> tempfile.sh


chmod +x tempfile.sh
./tempfile.sh

echo -e "  "${array[0]}"cli:
    container_name: "${array[0]}"cli
    image: hyperledger/fabric-tools:latest
    tty: true
    stdin_open: true
    environment:
      - GOPATH=/opt/gopath
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      #- CORE_LOGGING_LEVEL=DEBUG
      - CORE_LOGGING_LEVEL=INFO
      - CORE_PEER_ID="${array[0]}"cli
      - CORE_PEER_ADDRESS=peer0."${array[0]}"."$nameofnetwork".com:"$port1"
      - CORE_PEER_LOCALMSPID="${array[0]}"MSP
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"${array[0]}"."$nameofnetwork".com/peers/peer0."${array[0]}"."$nameofnetwork".com/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"${array[0]}"."$nameofnetwork".com/peers/peer0."${array[0]}"."$nameofnetwork".com/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"${array[0]}"."$nameofnetwork".com/peers/peer0."${array[0]}"."$nameofnetwork".com/tls/ca.crt
      - CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"${array[0]}"."$nameofnetwork".com/users/Admin@"${array[0]}"."$nameofnetwork".com/msp
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: /bin/bash
    volumes:
        - /var/run/:/host/var/run/
        - ./../chaincode/:/opt/gopath/src/github.com/chaincode
        - ./crypto-config:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/
        - ./scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/
        - ./channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts
    depends_on:" >>docker-compose-e2e-${array[0]}.yaml

for (( j=0; j<${array[1]}; j++ ));
do
echo -e "      - peer"$j"."${array[0]}"."$nameofnetwork".com" >>docker-compose-e2e-${array[0]}.yaml
done

echo -e "    networks:
      - byfn">>docker-compose-e2e-${array[0]}.yaml

echo "############################################################################################################
############################    Additiion of New Org $orgname  in Backend Wait !!!!!!!!!!!!#################
############################################################################################################"

docker-compose -f docker-compose-e2e-${array[0]}.yaml --project-name $nameofnetwork up -d 2>&1 

sleep 5

echo "############################    creating  ${array[0]}.json file  ##############################"

../bin/configtxgen -printOrg ${array[0]}MSP  > ./channel-artifacts/${array[0]}.json

echo "############################################################################################################
############################    New Org $orgname is added to $nameofnetwork   ##############################
############################################################################################################"


