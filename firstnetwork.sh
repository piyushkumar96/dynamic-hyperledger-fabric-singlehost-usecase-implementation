#!/bin/bash

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}

nameofnetwork=$1
nooforgs=$2

echo -e '# ---------------------------------------------------------------------------
# "OrdererOrgs" - Definition of organizations managing orderer nodes
# ---------------------------------------------------------------------------
OrdererOrgs:
  # ---------------------------------------------------------------------------
  # Orderer
  # ---------------------------------------------------------------------------
  - Name: Orderer
    Domain: '$nameofnetwork'.com
    # ---------------------------------------------------------------------------
    # "Specs" - See PeerOrgs below for complete description
    # ---------------------------------------------------------------------------
    Specs:
      - Hostname: orderer
# ---------------------------------------------------------------------------
# "PeerOrgs" - Definition of organizations managing peer nodes
# ---------------------------------------------------------------------------
PeerOrgs: ' > crypto-config.yaml

echo -e '################################################################################
#
#   Profile
#
#   - Different configuration profiles may be encoded here to be specified
#   as parameters to the configtxgen tool
#
################################################################################
Profiles:

    OrdererGenesis:
        Capabilities:
            <<: *ChannelCapabilities
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererOrg
            Capabilities:
                <<: *OrdererCapabilities
        Consortiums:
            SampleConsortium:
                Organizations:'>configtx.yaml
shift 2
array=( "$@" )
arraylength=${#array[@]}

echo -n '{   "nameofnetwork" : "'$nameofnetwork'", "nooforgs" : "'$nooforgs'" , "firstorg" : "'${array[0]}'"'> ./network-configuration/orgstructure.json

#################################################    making peer-base.yaml file                 #############################################

echo -e "version: '2'

services:
  peer-base:
    image: hyperledger/fabric-peer:latest
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE="$nameofnetwork"_byfn
      - CORE_LOGGING_LEVEL=INFO
      #- CORE_LOGGING_LEVEL=DEBUG
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_GOSSIP_USELEADERELECTION=true
      - CORE_PEER_GOSSIP_ORGLEADER=false
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start" > ./base/peer-base.yaml

################################  creation of docker-compose-base.yaml file for firsttime network ####################################

echo -e "version: '2'

services:

  orderer."$nameofnetwork".com:
    container_name: orderer."$nameofnetwork".com
    image: hyperledger/fabric-orderer:latest
    environment:
      - ORDERER_GENERAL_LOGLEVEL=INFO
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=OrdererMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
      # enabled TLS
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    volumes:
    - ../channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
    - ../crypto-config/ordererOrganizations/"$nameofnetwork".com/orderers/orderer."$nameofnetwork".com/msp:/var/hyperledger/orderer/msp
    - ../crypto-config/ordererOrganizations/"$nameofnetwork".com/orderers/orderer."$nameofnetwork".com/tls/:/var/hyperledger/orderer/tls
    - orderer."$nameofnetwork".com:/var/hyperledger/production/orderer
    ports:
      - 7050:7050" > ./base/docker-compose-base.yaml

################################  creating configtx.yaml  ####################################
      echo -e '################################################################################
#
#   Section: Organizations
#
#   - This section defines the different organizational identities which will
#   be referenced later in the configuration.
#
################################################################################
Organizations:

    # SampleOrg defines an MSP using the sampleconfig.  It should never be used
    # in production but may be used as a template for other definitions
    - &OrdererOrg
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: OrdererOrg

        # ID to load the MSP definition as
        ID: OrdererMSP

        # MSPDir is the filesystem path which contains the MSP configuration
        MSPDir: crypto-config/ordererOrganizations/'$nameofnetwork'.com/msp
        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('\''OrdererMSP.member'\'')"
            Writers:
                Type: Signature
                Rule: "OR('\''OrdererMSP.member'\'')"
            Admins:
                Type: Signature
                Rule: "OR('\''OrdererMSP.admin'\'')"   ' >configtx.yaml


########################################################  creating utils.sh file   #######################################################
echo -e '

setGlobals () {
PEER=$1
ORG=$2'> ./scripts/utils.sh

################################  storing the ports of peers of orgs ./network-configuration/orgsports.json in file   ##############################################
echo -n '{ "org": ['> ./network-configuration/orgsports.json


for (( i=1,k=1; i<${arraylength}+1; i=i+2,k++ ));
do
   if [ $i -ne 1 ]; then 
     echo -n ', '>> ./network-configuration/orgsports.json
   fi
   echo -n '{ "orgId" : "'${array[$i-1]}'", "peer" : ['>> ./network-configuration/orgsports.json
   for (( j=0; j<${array[$i]}; j++ ));
   do
    input=$(cat ./network-configuration/portpeer.txt)
    varport1=$(($input+1))
    varport2=$(($input+2))
    if [ $j -eq 0 ]; then
      echo -e '  peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:
      container_name: peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com
      extends:
        file: peer-base.yaml
        service: peer-base
      environment:
        - CORE_PEER_ID=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com
        - CORE_PEER_LISTENADDRESS=0.0.0.0:'$varport1'           
        - CORE_PEER_ADDRESS=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$varport1'
        - CORE_PEER_GOSSIP_BOOTSTRAP=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$varport1'
        - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$varport1'
        - CORE_PEER_LOCALMSPID='${array[$i-1]}'MSP
      volumes:
          - /var/run/:/host/var/run/
          - ../crypto-config/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com/msp:/etc/hyperledger/fabric/msp
          - ../crypto-config/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com/tls:/etc/hyperledger/fabric/tls
          - peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:/var/hyperledger/production
      ports:
        - '$varport1':'$varport1'
        - '$varport2':'$varport2 >> ./base/docker-compose-base.yaml


        echo -e '    - &'${array[$i-1]}'
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: '${array[$i-1]}'MSP

        # ID to load the MSP definition as
        ID: '${array[$i-1]}'MSP

        MSPDir: crypto-config/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/msp

        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('\'''${array[$i-1]}'MSP.admin'\'', '\'''${array[$i-1]}'MSP.peer'\'', '\'''${array[$i-1]}'MSP.client'\'')"
            Writers:
                Type: Signature
                Rule: "OR('\'''${array[$i-1]}'MSP.admin'\'', '\'''${array[$i-1]}'MSP.client'\'')"
            Admins:
                Type: Signature
                Rule: "OR('\'''${array[$i-1]}'MSP.admin'\'')"

        AnchorPeers:
            # AnchorPeers defines the location of peers which can be used
            # for cross org gossip communication.  Note, this value is only
            # encoded in the genesis block in the Application section context
            - Host: peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com
              Port: '$varport1 >> configtx.yaml

        
        if [ $i -eq 1 ]; then
          echo -e 'if [ $ORG == "'${array[$i-1]}'" ] ; then
          set -x
          CORE_PEER_LOCALMSPID="'${array[$i-1]}'MSP"
          CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com/tls/ca.crt
          CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/users/Admin@'${array[$i-1]}'.'$nameofnetwork'.com/msp
          set +x
          if [ $PEER -eq '$j' ]; then
            set -x
            CORE_PEER_ADDRESS=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$varport1' 
            set +x' >> ./scripts/utils.sh
        else
          echo -e 'elif [ $ORG == "'${array[$i-1]}'" ] ; then
          set -x
          CORE_PEER_LOCALMSPID="'${array[$i-1]}'MSP"
          CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com/tls/ca.crt
          CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/users/Admin@'${array[$i-1]}'.'$nameofnetwork'.com/msp
          set +x
          if [ $PEER -eq '$j' ]; then
            set -x
            CORE_PEER_ADDRESS=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$varport1' 
            set +x' >> ./scripts/utils.sh
        fi

        echo -n '{ "peerName" : "peer'$j'" , "port" : "'$varport1'" }'>> ./network-configuration/orgsports.json
 
        port1=$varport1
        port2=$varport2
        firstorg=${array[$i-1]}
        echo $varport2 >./network-configuration/portpeer.txt
     else
      echo -e '  peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:
      container_name: peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com
      extends:
        file: peer-base.yaml
        service: peer-base
      environment:
        - CORE_PEER_ID=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com
        - CORE_PEER_LISTENADDRESS=0.0.0.0:'$port1'           
        - CORE_PEER_ADDRESS=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$port1'
        - CORE_PEER_GOSSIP_BOOTSTRAP=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$port1'
        - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$port1'
        - CORE_PEER_LOCALMSPID='${array[$i-1]}'MSP
      volumes:
          - /var/run/:/host/var/run/
          - ../crypto-config/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com/msp:/etc/hyperledger/fabric/msp
          - ../crypto-config/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/peers/peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com/tls:/etc/hyperledger/fabric/tls
          - peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:/var/hyperledger/production
      ports:
        - '$varport1':'$port1'
        - '$varport2':'$port2 >> ./base/docker-compose-base.yaml
      
      echo -e '          elif [ $PEER -eq '$j' ]; then
            set -x
            CORE_PEER_ADDRESS=peer'$j'.'${array[$i-1]}'.'$nameofnetwork'.com:'$port1'
            set +x' >> ./scripts/utils.sh
      
      echo -n ', { "peerName" : "peer'$j'" , "port" : "'$varport1'" }'>> ./network-configuration/orgsports.json

      echo $varport2 >./network-configuration/portpeer.txt
      fi
   done 
   echo -n '] }'>> ./network-configuration/orgsports.json
   echo -e '#newpeer'${array[$i-1]}'
          fi' >> ./scripts/utils.sh
done    

#####################################  for future addition of new org anchor peer   ########################################################
echo -e '\n#newanchorpeer' >> configtx.yaml

echo -n '], "caports": [ '>> ./network-configuration/orgsports.json 

echo -e '#neworg
else
		echo "================== ERROR !!! ORG Unknown =================="
fi

}' >> ./scripts/utils.sh

chmod +x ./scripts/utils.sh

########################################### Inserting orderer details in configtx.yaml  ################################################################

echo -e '################################################################################
#
#   SECTION: Orderer
#
#   - This section defines the values to encode into a config transaction or
#   genesis block for orderer related parameters
#
################################################################################
Orderer: &OrdererDefaults

    # Orderer Type: The orderer implementation to start
    # Available types are "solo" and "kafka"
    OrdererType: solo

    Addresses:
        - orderer.'$nameofnetwork'.com:7050

    # Batch Timeout: The amount of time to wait before creating a batch
    BatchTimeout: 2s

    # Batch Size: Controls the number of messages batched into a block
    BatchSize:

        # Max Message Count: The maximum number of messages to permit in a batch
        MaxMessageCount: 10

        # Absolute Max Bytes: The absolute maximum number of bytes allowed for
        # the serialized messages in a batch.
        AbsoluteMaxBytes: 99 MB

        # Preferred Max Bytes: The preferred maximum number of bytes allowed for
        # the serialized messages in a batch. A message larger than the preferred
        # max bytes will result in a batch larger than preferred max bytes.
        PreferredMaxBytes: 512 KB

    Kafka:
        # Brokers: A list of Kafka brokers to which the orderer connects
        # NOTE: Use IP:port notation
        Brokers:
            - 127.0.0.1:9092

    # Organizations is the list of orgs which are defined as participants on
    # the orderer side of the network
    Organizations:

################################################################################
#
#   SECTION: Application
#
#   - This section defines the values to encode into a config transaction or
#   genesis block for application related parameters
#
################################################################################
Application: &ApplicationDefaults

    # Organizations is the list of orgs which are defined as participants on
    # the application side of the network
    Organizations:

################################################################################
#
#   SECTION: Capabilities
#
#   - This section defines the capabilities of fabric network. This is a new
#   concept as of v1.1.0 and should not be utilized in mixed networks with
#   v1.0.x peers and orderers.  Capabilities define features which must be
#   present in a fabric binary for that binary to safely participate in the
#   fabric network.  For instance, if a new MSP type is added, newer binaries
#   might recognize and validate the signatures from this type, while older
#   binaries without this support would be unable to validate those
#   transactions.  This could lead to different versions of the fabric binaries
#   having different world states.  Instead, defining a capability for a channel
#   informs those binaries without this capability that they must cease
#   processing transactions until they have been upgraded.  For v1.0.x if any
#   capabilities are defined (including a map with all capabilities turned off)
#   then the v1.0.x peer will deliberately crash.
#
################################################################################
Capabilities:
    # Channel capabilities apply to both the orderers and the peers and must be
    # supported by both.  Set the value of the capability to true to require it.
    Global: &ChannelCapabilities
        # V1.1 for Global is a catchall flag for behavior which has been
        # determined to be desired for all orderers and peers running v1.0.x,
        # but the modification of which would cause incompatibilities.  Users
        # should leave this flag set to true.
        V1_1: true

    # Orderer capabilities apply only to the orderers, and may be safely
    # manipulated without concern for upgrading peers.  Set the value of the
    # capability to true to require it.
    Orderer: &OrdererCapabilities
        # V1.1 for Order is a catchall flag for behavior which has been
        # determined to be desired for all orderers running v1.0.x, but the
        # modification of which  would cause incompatibilities.  Users should
        # leave this flag set to true.
        V1_1: true

    # Application capabilities apply only to the peer network, and may be safely
    # manipulated without concern for upgrading orderers.  Set the value of the
    # capability to true to require it.
    Application: &ApplicationCapabilities
        # V1.1 for Application is a catchall flag for behavior which has been
        # determined to be desired for all peers running v1.0.x, but the
        # modification of which would cause incompatibilities.  Users should
        # leave this flag set to true.
        V1_1: true

################################################################################
#
#   Profile
#
#   - Different configuration profiles may be encoded here to be specified
#   as parameters to the configtxgen tool
#
################################################################################
Profiles:

    OrdererGenesis:
        Capabilities:
            <<: *ChannelCapabilities
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererOrg
            Capabilities:
                <<: *OrdererCapabilities
        Consortiums:
            SampleConsortium:
                Organizations:'>> configtx.yaml



echo -n '{ '> ./network-configuration/cliname.json

################################ orgjson.sh file produces org.json file require forn channel artifacts generation ##############################
echo -e '#!/bin/bash 
' > ./orgjson.sh

######################################### addition of Organizations configuration in crypto-config.yaml ##################################################
for (( i=1; i<${arraylength}+1; i=i+2 ));
do
   echo -e '- Name: '${array[$i-1]}'
  Domain: '${array[$i-1]}'.'$nameofnetwork'.com
  EnableNodeOUs: true
  Template:
   Count: '${array[$i]}'
  Users:
   Count: 1
'>>crypto-config.yaml

  ######################################### folder creation for organization  ##################################################
  mkdir -p ${array[$i-1]}

  ############################# storing the orgsname with their no. of peer in  ./network-configuration/orgstructure.json file #########################
  echo -n ','>> ./network-configuration/orgstructure.json
  echo -n '    "'${array[$i-1]}'" : "'${array[$i]}'" '>> ./network-configuration/orgstructure.json

  ############################# storing the orgcli name in  ./network-configuration/cliname.json file ##########################
  if [ $i -ne 1 ]; then 
    echo -n ', '>> ./network-configuration/cliname.json
  fi
  echo -n '"'${array[$i-1]}'" : "'$nameofnetwork'cli"'>> ./network-configuration/cliname.json

  ############################# adding orgsname in  configtx.yaml file ##########################
  echo -e '                    - *'${array[$i-1]} >>configtx.yaml

  ################################ append data in orgjson.sh file ##############################
  echo -e '../bin/configtxgen -printOrg '${array[$i-1]}'MSP  > ./channel-artifacts/'${array[$i-1]}'.json' >> orgjson.sh
done

chmod +x orgjson.sh

#####################################  for future addition of new orgs in Consortiums   ########################################################
echo -e '#neworgconsortium' >> configtx.yaml

#####################################  for future addition of new orgs in crypto-config   ########################################################
echo -e '\n#neworgcryptoconfig' >> crypto-config.yaml

echo -e ',"networkstatus":"down"  }'>> ./network-configuration/orgstructure.json

echo -n ' }'>> ./network-configuration/cliname.json


#############################  creating the docker-compose-e2e-template.yaml  #####################################

echo -e "version: '2'

volumes:
  orderer."$nameofnetwork".com:" >docker-compose-e2e-template.yaml

for (( i=1; i<${arraylength}+1; i=i+2 ));
do
   for (( j=0; j<${array[$i]}; j++ ));
   do
     echo -e "  peer"$j"."${array[$i-1]}"."$nameofnetwork".com:" >>docker-compose-e2e-template.yaml
   done
done



echo -e "
networks:
  byfn:
services:" >>docker-compose-e2e-template.yaml

for (( i=1,j=0; i<${arraylength}+1; i=i+2,j++ ));
do
    input1=$(cat ./network-configuration/portca.txt)
    varport3=$(($input1+1))
    if [ $i -ne 1 ]; then 
     echo -n ', '>> ./network-configuration/orgsports.json
    fi
    if [ $i -eq 1 ]; then 
    echo -n '{ "orgId":"org1", "port" :"'$varport3'"}, ' >> ./network-configuration/orgsports.json
    fi
    echo -n '{ "orgId":"'${array[$i-1]}'", "port" :"'$varport3'"}' >> ./network-configuration/orgsports.json
    if [ $i -eq 1 ]; then
      echo -e "  ca"${array[$i-1]}":
          image: hyperledger/fabric-ca:latest
          environment:
            - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
            - FABRIC_CA_SERVER_CA_NAME=ca-"${array[$i-1]}"
            - FABRIC_CA_SERVER_TLS_ENABLED=true
            - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server-config/ca."${array[$i-1]}"."$nameofnetwork".com-cert.pem
            - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server-config/CA"$j"_PRIVATE_KEY      
          ports:
            - "$varport3:$varport3"
          command: sh -c 'fabric-ca-server start --ca.certfile /etc/hyperledger/fabric-ca-server-config/ca."${array[$i-1]}"."$nameofnetwork".com-cert.pem --ca.keyfile /etc/hyperledger/fabric-ca-server-config/CA"$j"_PRIVATE_KEY -b admin:adminpw -d'
          volumes:
            - ./crypto-config/peerOrganizations/"${array[$i-1]}"."$nameofnetwork".com/ca/:/etc/hyperledger/fabric-ca-server-config
          container_name: ca_peer"${array[$i-1]}"
          networks:
            - byfn" >>docker-compose-e2e-template.yaml
            tempport=$varport3
      echo $varport3 >./network-configuration/portca.txt
    else
      echo -e "  ca"${array[$i-1]}":
          image: hyperledger/fabric-ca:latest
          environment:
            - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
            - FABRIC_CA_SERVER_CA_NAME=ca-"${array[$i-1]}"
            - FABRIC_CA_SERVER_TLS_ENABLED=true
            - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server-config/ca."${array[$i-1]}"."$nameofnetwork".com-cert.pem
            - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server-config/CA"$j"_PRIVATE_KEY      
          ports:
            - "$varport3:$tempport"
          command: sh -c 'fabric-ca-server start --ca.certfile /etc/hyperledger/fabric-ca-server-config/ca."${array[$i-1]}"."$nameofnetwork".com-cert.pem --ca.keyfile /etc/hyperledger/fabric-ca-server-config/CA"$j"_PRIVATE_KEY -b admin:adminpw -d'
          volumes:
            - ./crypto-config/peerOrganizations/"${array[$i-1]}"."$nameofnetwork".com/ca/:/etc/hyperledger/fabric-ca-server-config
          container_name: ca_peer"${array[$i-1]}"
          networks:
            - byfn" >>docker-compose-e2e-template.yaml
            tempport=$varport3
      echo $varport3 >./network-configuration/portca.txt
    fi 
done

#################  closing of caports in ./network-configuration/orgstructure.json file  ################################
echo -n '] }' >> ./network-configuration/orgsports.json

#############################  appending more details in  docker-compose-e2e-template.yaml  #####################################

for (( i=1; i<${arraylength}+1; i=i+2 ));
do
   for (( j=0; j<${array[$i]}; j++ ));
   do
     echo -e "  peer"$j"."${array[$i-1]}"."$nameofnetwork".com:
    container_name: peer"$j"."${array[$i-1]}"."$nameofnetwork".com
    extends:
      file:  base/docker-compose-base.yaml
      service: peer"$j"."${array[$i-1]}"."$nameofnetwork".com
    networks:
      - byfn" >>docker-compose-e2e-template.yaml
   done
done   

echo -e "  orderer."$nameofnetwork".com:
    extends:
      file:   base/docker-compose-base.yaml
      service: orderer."$nameofnetwork".com
    container_name: orderer."$nameofnetwork".com
    networks:
      - byfn" >>docker-compose-e2e-template.yaml

echo -e "  "$nameofnetwork"cli:
    container_name: "$nameofnetwork"cli
    image: hyperledger/fabric-tools:latest
    tty: true
    stdin_open: true
    environment:
      - GOPATH=/opt/gopath
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      #- CORE_LOGGING_LEVEL=DEBUG
      - CORE_LOGGING_LEVEL=INFO
      - CORE_PEER_ID="$nameofnetwork"cli
      - CORE_PEER_ADDRESS=peer0."$firstorg"."$nameofnetwork".com:"$port1"
      - CORE_PEER_LOCALMSPID="$nameofnetwork"MSP
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$firstorg"."$nameofnetwork".com/peers/peer0."$firstorg"."$nameofnetwork".com/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$firstorg"."$nameofnetwork".com/peers/peer0."$firstorg"."$nameofnetwork".com/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$firstorg"."$nameofnetwork".com/peers/peer0."$firstorg"."$nameofnetwork".com/tls/ca.crt
      - CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$firstorg"."$nameofnetwork".com/users/Admin@"$firstorg"."$nameofnetwork".com/msp
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: /bin/bash  
    volumes:
        - /var/run/:/host/var/run/
        - ./../chaincode/:/opt/gopath/src/github.com/chaincode
        - ./crypto-config:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/
        - ./scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/
        - ./channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts
    depends_on:
      - orderer."$nameofnetwork".com" >>docker-compose-e2e-template.yaml

for (( i=1; i<${arraylength}+1; i=i+2 ));
do
   for (( j=0; j<${array[$i]}; j++ ));
   do
     echo -e "      - peer"$j"."${array[$i-1]}"."$nameofnetwork".com" >>docker-compose-e2e-template.yaml
   done
done

echo -e "    networks:
      - byfn">>docker-compose-e2e-template.yaml



#################  creating the replaceprivatekeys.sh file for replacing the keys of CAs in docker-compose-e2e.yaml  ################################

echo -e '#!/bin/bash
# Copy the template to the file that will be modified to add the private key
  cp docker-compose-e2e-template.yaml docker-compose-e2e.yaml

  # The next steps will replace the templates contents with the
  # actual values of the private key file names for the two CAs.
  CURRENT_DIR=$PWD' > replaceprivatekeys.sh 

for (( i=1,j=0; i<${arraylength}+1; i=i+2,j++ ));
do
echo -e 'cd crypto-config/peerOrganizations/'${array[$i-1]}'.'$nameofnetwork'.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed -i "s/CA'$j'_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml' >> replaceprivatekeys.sh 
done

chmod +x replaceprivatekeys.sh

############################  cryptogeneration.sh file for generating cryptos ######################################

echo -e '#!/bin/bash

  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  echo
  echo "##########################################################"
  echo "##### Generate certificates using cryptogen tool #########"
  echo "##########################################################"

  if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
  fi
  set -x
  ../bin/cryptogen generate --config=./crypto-config.yaml
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo' >cryptogeneration.sh

  chmod +x cryptogeneration.sh

############################  channelartifactsgen.sh file for generating channel artifacts ######################################

  echo -e '#!/bin/bash
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi

  echo "##########################################################"
  echo "#########  Generating Orderer Genesis block ##############"
  echo "##########################################################"
  # Note: For some unknown reason (at least for now) the block file cant be
  # named orderer.genesis.block or the orderer will fail to launch!
  set -x
  ../bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate orderer genesis block..."
    exit 1
  fi
  echo' > channelartifactsgen.sh

  chmod +x channelartifactsgen.sh

############################  appending the more functions to utils.sh file   #########################

echo -e '

verifyResult () {
	if [ $1 -ne 0 ] ; then
		echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute End-2-End Scenario ==========="
		echo
   		exit 1
	fi
}

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
        CORE_PEER_LOCALMSPID="OrdererMSP"
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/users/Admin@'$nameofnetwork'.com/msp
}

createChannel() {
        
        setGlobals $1 $2
        
        if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
                      set -x
          peer channel create -o orderer.'$nameofnetwork'.com:7050 -c $3 -f ./channel-artifacts/$3channel.tx >&log.txt
          res=$?
                      set +x
        else
              set -x
          peer channel create -o orderer.'$nameofnetwork'.com:7050 -c $3 -f ./channel-artifacts/$3channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem >&log.txt
          res=$?
              set +x
        fi
        cat log.txt
        verifyResult $res "Channel creation failed"
        echo "===================== Channel \"$3\" is created successfully ===================== "
        echo
}

joinChannelWithRetry () {
	PEER=$1
	ORG=$2
  CHANNEL_NAME=$3

	setGlobals $PEER $ORG

  set -x
	peer channel join -b $CHANNEL_NAME.block  >&log.txt
	res=$?
  set +x
	cat log.txt
	if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
		COUNTER=` expr $COUNTER + 1`
		echo "peer${PEER}.org${ORG} failed to join the channel, Retry after $DELAY seconds"
		sleep $DELAY
		joinChannelWithRetry $PEER $ORG $CHANNEL_NAME
	else
		COUNTER=1
	fi
	verifyResult $res "After $MAX_RETRY attempts, ${PEER}.${ORG} has failed to Join the Channel"
}



' >> ./scripts/utils.sh

######################################## scripts for joining channel     ##########################################################

echo -e '#!/bin/bash 

peer=$1
orgname=$2
channelname=$3
. ./scripts/utils.sh 

joinChannelWithRetry $peer $orgname $channelname

'> ./scripts/joinchannelscript.sh

chmod +x ./scripts/joinchannelscript.sh


echo -e '#!/bin/bash 

########################## updateing no of peer in crypto-config.yaml #########################################

peerno=$1
orgname=$2
channelname=$3

cliname=$(python operations.py getCliName $orgname)

docker exec $cliname scripts/joinchannelscript.sh $peerno $orgname $channelname

python operations.py addPeerJoinChannel $channelname $orgname $peerno

' > joinchannel.sh

chmod +x joinchannel.sh 


#####################################################     script for adding new peer to org   ###############################################

echo -e '#!/bin/bash

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

echo -e "version: '\''2'\''

volumes:
  peer"$peerno"."$orgname".'$nameofnetwork'.com:

networks:
  byfn:

services:

  peer"$peerno"."$orgname".'$nameofnetwork'.com:
    container_name: peer"$peerno"."$orgname".'$nameofnetwork'.com
    extends:
      file: ../base/peer-base.yaml
      service: peer-base
    environment:
      - CORE_PEER_ID=peer"$peerno"."$orgname".'$nameofnetwork'.com
      - CORE_PEER_LISTENADDRESS=0.0.0.0:"$port1"
      - CORE_PEER_ADDRESS=peer"$peerno"."$orgname".'$nameofnetwork'.com:"$port1"
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer"$peerno"."$orgname".'$nameofnetwork'.com:"$port1"
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0."$orgname".'$nameofnetwork'.com:"$port1"
      - CORE_PEER_LOCALMSPID="$orgname"MSP
    volumes:
      - /var/run/:/host/var/run/
      - ../crypto-config/peerOrganizations/"$orgname".'$nameofnetwork'.com/peers/peer$peerno."$orgname".'$nameofnetwork'.com/msp:/etc/hyperledger/fabric/msp
      - ../crypto-config/peerOrganizations/"$orgname".'$nameofnetwork'.com/peers/peer$peerno."$orgname".'$nameofnetwork'.com/tls:/etc/hyperledger/fabric/tls
    ports:
      - "$varp1":"$port1"
      - "$varp2":"$port2"
    networks:
      - byfn " >./$orgname/docker-compose-base-peer$peerno.yaml


sed -i "s/#newpeer${orgname}/          elif [ \$PEER -eq ${peerno} ]; then \\n           set -x \\n           CORE_PEER_ADDRESS=peer${peerno}.${orgname}.'${nameofnetwork}'.com:${port1} \\n           set +x \\n#newpeer${orgname}/" scripts/utils.sh

docker-compose -f ./$orgname/docker-compose-base-peer$peerno.yaml --project-name '$nameofnetwork' up -d 2>&1 
sleep 5

echo "############################################################################################################
      ############################    New Peer$peerno is added to $orgname        ################################
      ############################################################################################################"


'> addnewpeer.sh

chmod +x addnewpeer.sh