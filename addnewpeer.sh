#!/bin/bash

orgname=$1

########################## updateing no of peer in crypto-config.yaml #########################################

python operations.py changeYamlCount $orgname

#####################################  for future addition of new orgs in Consortiums   ########################################################
echo -e "#neworgcryptoconfig" >> crypto-config.yaml

########################## updateing no of peer in ./network-configuration/orgstructure.json #########################################

python operations.py updateOrgCount $orgname

############################## creating the keys for new peer   #############################################
../bin/cryptogen extend --config=./crypto-config.yaml

############################## ports for new peer  ##########################################################
input=$(cat ./network-configuration/portpeer.txt)
varp1=$(($input+1))
varp2=$(($input+2))

echo $varp2 >./network-configuration/portpeer.txt


########################## reading ports of anchor peer of new peer and get no of peer in ./network-configuration/orgstructure.json #########################################


port1=$(python operations.py getPeerPort $orgname "peer0")
pno=$(python operations.py getOrgCount $orgname)
peerno=$(($pno-1))
port2=$(($port1+1))

############################# append ports details of new peer in appendpeerport.py file ##################### 
python operations.py addPeerPort $orgname peer$peerno $varp1


#############################  creating the new peer docker-compose-base.yaml file   ######################### 

echo -e "version: '2'

volumes:
  peer"$peerno"."$orgname".bankconsortiumbcnet.com:

networks:
  byfn:

services:

  peer"$peerno"."$orgname".bankconsortiumbcnet.com:
    container_name: peer"$peerno"."$orgname".bankconsortiumbcnet.com
    extends:
      file: ../base/peer-base.yaml
      service: peer-base
    environment:
      - CORE_PEER_ID=peer"$peerno"."$orgname".bankconsortiumbcnet.com
      - CORE_PEER_LISTENADDRESS=0.0.0.0:"$port1"
      - CORE_PEER_ADDRESS=peer"$peerno"."$orgname".bankconsortiumbcnet.com:"$port1"
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer"$peerno"."$orgname".bankconsortiumbcnet.com:"$port1"
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0."$orgname".bankconsortiumbcnet.com:"$port1"
      - CORE_PEER_LOCALMSPID="$orgname"MSP
    volumes:
      - /var/run/:/host/var/run/
      - ../crypto-config/peerOrganizations/"$orgname".bankconsortiumbcnet.com/peers/peer$peerno."$orgname".bankconsortiumbcnet.com/msp:/etc/hyperledger/fabric/msp
      - ../crypto-config/peerOrganizations/"$orgname".bankconsortiumbcnet.com/peers/peer$peerno."$orgname".bankconsortiumbcnet.com/tls:/etc/hyperledger/fabric/tls
    ports:
      - "$varp1":"$port1"
      - "$varp2":"$port2"
    networks:
      - byfn " >./$orgname/docker-compose-base-peer$peerno.yaml


sed -i "s/#newpeer${orgname}/          elif [ \$PEER -eq ${peerno} ]; then \n           set -x \n           CORE_PEER_ADDRESS=peer${peerno}.${orgname}.bankconsortiumbcnet.com:${port1} \n           set +x \n#newpeer${orgname}/" scripts/utils.sh

docker-compose -f ./$orgname/docker-compose-base-peer$peerno.yaml --project-name bankconsortiumbcnet up -d 2>&1 
sleep 5

echo "############################################################################################################
      ############################    New Peer$peerno is added to $orgname        ################################
      ############################################################################################################"



