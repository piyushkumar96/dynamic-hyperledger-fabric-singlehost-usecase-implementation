# dynamic-hyperledger-fabric-singlehost

## This repository contains scripts to spawn the dynamic hyperledger fabric network in single host environment on local as well as cloud (AWS. AZURE etc.). Explain  with the help of an usecase **BANKCONSORTIUMBCNET**. 

**In This Blockchain Network UseCase :-** 

1. Initially there were **3** orgs (banks) **sbi**,**hdfc**,**icici** having **2**, **3**, and **4** peers respectively. There were **2** channels first **chsbihdfc** (in which initially sbi and hdfc are present) and **chhdfcicici** (in which initially hdfc and icici are present) using **firstnetwork.sh** and **configtx-file-gen.sh** scripts.

2. Then I had **UP** the initial blockchain network which consists of **3 ORGs, 9 PEERS, 3 CAs, 2 CHANNELS** using **firstnetworkup.sh** script.

3. After this I used the scripts to join peers using **joinchannel.sh** script.

4. Added new peer to exsisting org using **addnewpeer.sh** script.

5. Created the new org **pnb** (bank) to exsisting blockchain network with 2 peers using **newOrgAddtion.sh** script.

6. Created new channel **createChannel.sh** script.

7. Adding org to channel in which it is not present using **addOrgToChannel.sh** script.

## Note:- I also wrote scripts which spawn dynamic hyperledger fabric network in multi host environment on local as well as cloud (AWS, AZURE etc). `(with install and instantiate chaincode also)  **(productionized, kubernetes cluster, flaut tolerance, kafka, zookeeper, multi orderer)**`.  


## Technology STACK
1. Hyperledger Fabric(v1.4)
2. Golang and Nodejs (Chaincode)
3. Docker & Container
4. Shell Scripting
5. Python

## System and Software Requirments
1. Ubuntu, Docker, Golang, Python.
2. Download hypeledger fabric binaries like cryptogen, configtxgen etc. basic bin folder of fabric-samples outside the this repo (after clonning).
3. Download Chaincode folder just outside this repo (after clonning).


                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                @@@@@ UseCase Example implementation  @@@@@
                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-----------------------------------------------------------------------------------------------------------------------------
                                                Intial Folder Structure
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ls**

addOrgToChannel.sh  channel-artifacts     createNewChannel.sh  network-configuration  operations.py   scripts

base                configtx-file-gen.sh  firstnetwork.sh      newChannelFiles        README.md       tempFolder

bcnetsetup.sh       createChannel.sh      firstnetworkup.sh    newOrgAddtion.sh       resetFolder.sh

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to create initial and blockchain network file
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./firstnetwork.sh bankconsortiumbcnet 3 sbi 2 hdfc 3 icici 4**

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ls**

addnewpeer.sh       channelartifactsgen.sh  crypto-config.yaml                hdfc                   newOrgAddtion.sh       resetFolder.sh

addOrgToChannel.sh  configtx-file-gen.sh    cryptogeneration.sh               icici                  operations.py          sbi

base                configtx.yaml           docker-compose-e2e-template.yaml  joinchannel.sh         orgjson.sh             scripts

bcnetsetup.sh       createChannel.sh        firstnetwork.sh                   network-configuration  README.md              tempFolder

channel-artifacts   createNewChannel.sh     firstnetworkup.sh                 newChannelFiles        replaceprivatekeys.sh

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to create the channel configuration files
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./configtx-file-gen.sh chsbihdfc sbi hdfc % chhdfcicici hdfc icici**

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ls**

addnewpeer.sh       channelartifactsgen.sh  crypto-config.yaml                hdfc                   newOrgAddtion.sh       resetFolder.sh

addOrgToChannel.sh  configtx-file-gen.sh    cryptogeneration.sh               icici                  operations.py          sbi

base                configtx.yaml           docker-compose-e2e-template.yaml  joinchannel.sh         orgjson.sh             scripts

bcnetsetup.sh       createChannel.sh        firstnetwork.sh                   network-configuration  README.md              tempFolder

channel-artifacts   createNewChannel.sh     firstnetworkup.sh                 newChannelFiles        replaceprivatekeys.sh

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to build the firstnetwork blockchain network 
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./firstnetworkup.sh**

############################################################

####### Generate certificates using cryptogen tool #########

############################################################

+ ../bin/cryptogen generate --config=./crypto-config.yaml

sbi.bankconsortiumbcnet.com

hdfc.bankconsortiumbcnet.com

icici.bankconsortiumbcnet.com

+ res=0
+ set +x

##########################################################

#########  Generating Orderer Genesis block ##############

##########################################################

+ ../bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block

2019-04-18 12:13:24.336 IST [common.tools.configtxgen] main -> WARN 001 Omitting the channel ID for configtxgen for output operations is deprecated.  Explicitly passing the channel ID will be required in the future, defaulting to 'testchainid'.

2019-04-18 12:13:24.337 IST [common.tools.configtxgen] main -> INFO 002 Loading configuration

2019-04-18 12:13:24.350 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.350 IST [common.tools.configtxgen.localconfig] Load -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.358 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 005 orderer type: solo

2019-04-18 12:13:24.358 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 006 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.358 IST [common.tools.configtxgen.encoder] NewChannelGroup -> WARN 007 Default policy emission is deprecated, please include policy specifications for the channel group in configtx.yaml

2019-04-18 12:13:24.358 IST [common.tools.configtxgen.encoder] NewOrdererGroup -> WARN 008 Default policy emission is deprecated, please include policy specifications for the orderer group in configtx.yaml

2019-04-18 12:13:24.361 IST [common.tools.configtxgen] doOutputBlock -> INFO 009 Generating genesis block

2019-04-18 12:13:24.371 IST [common.tools.configtxgen] doOutputBlock -> INFO 00a Writing genesis block
+ res=0
+ set +x

######################################################################
####### Generating channel configuration transaction chsbihdfc.tx ####
######################################################################

+ ../bin/configtxgen -profile chsbihdfcChannel -outputCreateChannelTx ./channel-artifacts/chsbihdfcchannel.tx -channelID chsbihdfc

2019-04-18 12:13:24.407 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:13:24.416 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.424 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.424 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.424 IST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 005 Generating new channel configtx

2019-04-18 12:13:24.424 IST [common.tools.configtxgen.encoder] NewApplicationGroup -> WARN 006 Default policy emission is deprecated, please include policy specifications for the application group in configtx.yaml

2019-04-18 12:13:24.425 IST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 007 Writing new channel tx
+ res=0
+ set +x

#################################################################

#######    Generating anchor peer update for sbiMSP   ###########

#################################################################

+ ../bin/configtxgen -profile chsbihdfcChannel -outputAnchorPeersUpdate ./channel-artifacts/sbiMSPanchorschsbihdfc.tx -channelID chsbihdfc -asOrg sbiMSP

2019-04-18 12:13:24.463 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:13:24.474 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.482 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.482 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.482 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Generating anchor peer update

2019-04-18 12:13:24.482 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 006 Writing anchor peer update
+ res=0
+ set +x

#################################################################

#######    Generating anchor peer update for hdfcMSP   ##########

#################################################################

+ ../bin/configtxgen -profile chsbihdfcChannel -outputAnchorPeersUpdate ./channel-artifacts/hdfcMSPanchorschsbihdfc.tx -channelID chsbihdfc -asOrg hdfcMSP

2019-04-18 12:13:24.518 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:13:24.527 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.535 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.535 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.535 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Generating anchor peer update

2019-04-18 12:13:24.535 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 006 Writing anchor peer update
+ res=0
+ set +x

#########################################################################

####### Generating channel configuration transaction chhdfcicici.tx #####

#########################################################################

+ ../bin/configtxgen -profile chhdfciciciChannel -outputCreateChannelTx ./channel-artifacts/chhdfcicicichannel.tx -channelID chhdfcicici

2019-04-18 12:13:24.572 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:13:24.582 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.589 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.590 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.590 IST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 005 Generating new channel configtx

2019-04-18 12:13:24.590 IST [common.tools.configtxgen.encoder] NewApplicationGroup -> WARN 006 Default policy emission is deprecated, please include policy specifications for the application group in configtx.yaml

2019-04-18 12:13:24.591 IST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 007 Writing new channel tx
+ res=0
+ set +x

#################################################################

#######    Generating anchor peer update for hdfcMSP   ##########

#################################################################

+ ../bin/configtxgen -profile chhdfciciciChannel -outputAnchorPeersUpdate ./channel-artifacts/hdfcMSPanchorschhdfcicici.tx -channelID chhdfcicici -asOrg hdfcMSP

2019-04-18 12:13:24.626 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:13:24.635 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.642 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.642 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.642 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Generating anchor peer update

2019-04-18 12:13:24.642 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 006 Writing anchor peer update
+ res=0
+ set +x

##################################################################

#######    Generating anchor peer update for iciciMSP   ##########

##################################################################

+ ../bin/configtxgen -profile chhdfciciciChannel -outputAnchorPeersUpdate ./channel-artifacts/iciciMSPanchorschhdfcicici.tx -channelID chhdfcicici -asOrg iciciMSP

2019-04-18 12:13:24.681 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:13:24.690 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.699 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 12:13:24.699 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:13:24.699 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Generating anchor peer update

2019-04-18 12:13:24.699 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 006 Writing anchor peer update
+ res=0
+ set +x

######################################################################################

######################    NETWORK CREATION IN PROGRESS     ###########################

######################################################################################

Creating network "bankconsortiumbcnet_byfn" with the default driver

Creating volume "bankconsortiumbcnet_peer2.icici.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_orderer.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer2.hdfc.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer0.hdfc.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer0.sbi.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer1.icici.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer1.hdfc.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer3.icici.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer1.sbi.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer0.icici.bankconsortiumbcnet.com" with default driver

Creating peer2.icici.bankconsortiumbcnet.com

Creating peer1.sbi.bankconsortiumbcnet.com

Creating peer3.icici.bankconsortiumbcnet.com

Creating ca_peersbi

Creating peer0.icici.bankconsortiumbcnet.com

Creating peer0.hdfc.bankconsortiumbcnet.com

Creating peer0.sbi.bankconsortiumbcnet.com

Creating peer1.icici.bankconsortiumbcnet.com

Creating peer2.hdfc.bankconsortiumbcnet.com

Creating ca_peerhdfc

Creating ca_peericici

Creating peer1.hdfc.bankconsortiumbcnet.com

Creating orderer.bankconsortiumbcnet.com

Creating bankconsortiumbcnetcli

#######################################################################################

#################################   NETWORK IS UP      ################################

#######################################################################################
+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x
+ peer channel create -o orderer.bankconsortiumbcnet.com:7050 -c chsbihdfc -f ./channel-artifacts/chsbihdfcchannel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
+ res=0
+ set +x

2019-04-18 06:44:42.732 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 06:44:42.774 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 06:44:42.874 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 06:44:43.088 UTC [cli.common] readBlock -> INFO 004 Received block: 0

===================== Channel "chsbihdfc" is created successfully ===================== 

+ CORE_PEER_LOCALMSPID=hdfcMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/peers/peer0.hdfc.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/users/Admin@hdfc.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.hdfc.bankconsortiumbcnet.com:7105
+ set +x
+ peer channel create -o orderer.bankconsortiumbcnet.com:7050 -c chhdfcicici -f ./channel-artifacts/chhdfcicicichannel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
+ res=0
+ set +x

2019-04-18 06:44:43.266 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 06:44:43.295 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 06:44:43.299 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 06:44:43.429 UTC [cli.common] readBlock -> INFO 004 Received block: 0

===================== Channel "chhdfcicici" is created successfully ===================== 

#################################################################################

##################    CHANNELS ARE CREATED         ##############################

#################################################################################

2019-04-18 12:14:44.226 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:14:44.236 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 002 orderer type: solo

2019-04-18 12:14:44.237 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:14:44.307 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:14:44.317 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 002 orderer type: solo

2019-04-18 12:14:44.317 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:14:44.363 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:14:44.376 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 002 orderer type: solo

2019-04-18 12:14:44.376 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to see the containers of blockchain network
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ docker ps**

CONTAINER ID        IMAGE                               COMMAND                  CREATED              STATUS              PORTS                                            NAMES

44a7a912fac6        hyperledger/fabric-tools:latest     "/bin/bash"              43 seconds ago       Up 33 seconds                                                        bankconsortiumbcnetcli

b7c3f2dd9610        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 48 seconds       0.0.0.0:7107->7105/tcp, 0.0.0.0:7108->7106/tcp   peer1.hdfc.bankconsortiumbcnet.com

ae0e7b1c2644        hyperledger/fabric-ca:latest        "sh -c 'fabric-ca-se…"   About a minute ago   Up 47 seconds       7054/tcp, 0.0.0.0:8002->8001/tcp                 ca_peerhdfc

b99d206f7a53        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 48 seconds       0.0.0.0:7117->7111/tcp, 0.0.0.0:7118->7112/tcp   peer3.icici.bankconsortiumbcnet.com

e06be2deeed0        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 48 seconds       0.0.0.0:7115->7111/tcp, 0.0.0.0:7116->7112/tcp   peer2.icici.bankconsortiumbcnet.com

5dabdc93e81d        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 48 seconds       0.0.0.0:7105-7106->7105-7106/tcp                 peer0.hdfc.bankconsortiumbcnet.com

861a7e5c91b0        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 43 seconds       0.0.0.0:7101-7102->7101-7102/tcp                 peer0.sbi.bankconsortiumbcnet.com

1f900f99b709        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 45 seconds       0.0.0.0:7113->7111/tcp, 0.0.0.0:7114->7112/tcp   peer1.icici.bankconsortiumbcnet.com

f50fc4a50e69        hyperledger/fabric-orderer:latest   "orderer"                About a minute ago   Up 48 seconds       0.0.0.0:7050->7050/tcp                           orderer.bankconsortiumbcnet.com

9a3629328fb9        hyperledger/fabric-ca:latest        "sh -c 'fabric-ca-se…"   About a minute ago   Up 44 seconds       7054/tcp, 0.0.0.0:8001->8001/tcp                 ca_peersbi

4c03e8c6bfd0        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 44 seconds       0.0.0.0:7111-7112->7111-7112/tcp                 peer0.icici.bankconsortiumbcnet.com

d5e9d154a06a        hyperledger/fabric-ca:latest        "sh -c 'fabric-ca-se…"   About a minute ago   Up 47 seconds       7054/tcp, 0.0.0.0:8003->8002/tcp                 ca_peericici

efc3cfa2a3fc        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 43 seconds       0.0.0.0:7109->7105/tcp, 0.0.0.0:7110->7106/tcp   peer2.hdfc.bankconsortiumbcnet.com

4240dda1c60b        hyperledger/fabric-peer:latest      "peer node start"        About a minute ago   Up 46 seconds       0.0.0.0:7103->7101/tcp, 0.0.0.0:7104->7102/tcp   peer1.sbi.bankconsortiumbcnet.com

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to join the channel by peer of an org
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./joinchannel.sh 0 sbi chsbihdfc**

+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x
+ peer channel join -b chsbihdfc.block
+ res=0
+ set +x

2019-04-18 07:13:31.220 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:13:31.237 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:13:31.268 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:13:31.851 UTC [channelCmd] executeJoin -> INFO 004 Successfully submitted proposal to join channel

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./joinchannel.sh 0 hdfc chsbihdfc**

+ CORE_PEER_LOCALMSPID=hdfcMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/peers/peer0.hdfc.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/users/Admin@hdfc.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.hdfc.bankconsortiumbcnet.com:7105
+ set +x
+ peer channel join -b chsbihdfc.block
+ res=0
+ set +x

2019-04-18 07:14:05.632 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:14:05.647 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:14:05.651 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:14:06.088 UTC [channelCmd] executeJoin -> INFO 004 Successfully submitted proposal to join channel

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add new peer to an org in exsisting blockchain network
-----------------------------------------------------------------------------------------------------------------------------

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addnewpeer.sh sbi**

Creating volume "bankconsortiumbcnet_peer2.sbi.bankconsortiumbcnet.com" with default driver

Creating peer2.sbi.bankconsortiumbcnet.com

############################################################################

################    New Peer2 is added to sbi        #######################

############################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                checking the new peer container is up or not 
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ docker ps**

CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS              PORTS                                            NAMES

d752b7a1c937        hyperledger/fabric-peer:latest      "peer node start"        5 minutes ago       Up 5 minutes        0.0.0.0:7119->7101/tcp, 0.0.0.0:7120->7102/tcp   peer2.sbi.bankconsortiumbcnet.com

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add new org in exsisting blockchain network
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./newOrgAddtion.sh pnb 2**

###########################################################################

########    Additiion of New Org pnb  in Backend Wait !!!!!!!!!!!!#########

###########################################################################

Creating volume "bankconsortiumbcnet_peer0.pnb.bankconsortiumbcnet.com" with default driver

Creating volume "bankconsortiumbcnet_peer1.pnb.bankconsortiumbcnet.com" with default driver

Creating ca_peerpnb

Creating peer1.pnb.bankconsortiumbcnet.com

Creating peer0.pnb.bankconsortiumbcnet.com

Creating pnbcli

############################    creating  pnb.json file  ##############################

2019-04-18 12:53:55.894 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 12:53:55.910 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 002 orderer type: solo

2019-04-18 12:53:55.910 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 003 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 12:53:55.911 IST [common.tools.configtxgen.encoder] NewOrdererOrgGroup -> WARN 004 Default policy emission is deprecated, please include policy specifications for the orderer org group pnbMSP in configtx.yaml

##########################################################################

#########    New Org pnb is added to bankconsortiumbcnet   ###############

##########################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                checking that containers of new org are spawned or not
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ docker ps**

CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS              PORTS                                            NAMES

20c347122944        hyperledger/fabric-tools:latest     "/bin/bash"              18 minutes ago      Up 18 minutes                                                        pnbcli

86ae07f6d32c        hyperledger/fabric-peer:latest      "peer node start"        18 minutes ago      Up 18 minutes       0.0.0.0:7121-7122->7121-7122/tcp                 peer0.pnb.bankconsortiumbcnet.com

dd127b153cbd        hyperledger/fabric-peer:latest      "peer node start"        18 minutes ago      Up 18 minutes       0.0.0.0:7123->7121/tcp, 0.0.0.0:7124->7122/tcp   peer1.pnb.bankconsortiumbcnet.com

89fb8b16cabe        hyperledger/fabric-ca:latest        "sh -c 'fabric-ca-se…"   18 minutes ago      Up 18 minutes       7054/tcp, 0.0.0.0:8004->8001/tcp                 ca_peerpnb

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ls**

addnewpeer.sh           configtx-file-gen.sh  cryptogeneration.sh               hdfc                   operations.py          scripts

addOrgToChannel.sh      configtx.yaml         docker-compose-e2e-pnb.yaml       icici                  pnb                    tempfile.sh

base                    createChannel.sh      docker-compose-e2e-template.yaml  joinchannel.sh         README.md              tempFolder

bcnetsetup.sh           createNewChannel.sh   docker-compose-e2e.yaml           network-configuration  replaceprivatekeys.sh

channel-artifacts       crypto-config         firstnetwork.sh                   newChannelFiles        resetFolder.sh

channelartifactsgen.sh  crypto-config.yaml    firstnetworkup.sh                 newOrgAddtion.sh       sbi

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to create new channel
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./createChannel.sh chall**

########################################################################

####### Generating channel configuration transaction challchannel.tx ###

########################################################################
+ ../bin/configtxgen -profile challChannel -outputCreateChannelTx ./channel-artifacts/challchannel.tx -channelID chall

2019-04-18 13:18:48.500 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 13:18:48.509 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 13:18:48.518 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 13:18:48.518 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 13:18:48.518 IST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 005 Generating new channel configtx

2019-04-18 13:18:48.518 IST [common.tools.configtxgen.encoder] NewApplicationGroup -> WARN 006 Default policy emission is deprecated, please include policy specifications for the application group in configtx.yaml

2019-04-18 13:18:48.520 IST [common.tools.configtxgen] doOutputChannelCreateTx -> INFO 007 Writing new channel tx
+ res=0
+ set +x

####################################################################################

############### Generating anchor peer update for sbiMSP for Channel chall #########

####################################################################################
+ ../bin/configtxgen -profile challChannel -outputAnchorPeersUpdate ./channel-artifacts/sbiMSPanchorschall.tx -channelID chall -asOrg sbiMSP

2019-04-18 13:18:48.555 IST [common.tools.configtxgen] main -> INFO 001 Loading configuration

2019-04-18 13:18:48.567 IST [common.tools.configtxgen.localconfig] Load -> INFO 002 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 13:18:48.576 IST [common.tools.configtxgen.localconfig] completeInitialization -> INFO 003 orderer type: solo

2019-04-18 13:18:48.576 IST [common.tools.configtxgen.localconfig] LoadTopLevel -> INFO 004 Loaded configuration: /home/piyushkumar/Documents/dynamic-hyperledger-fabric-singlehost-files/configtx.yaml

2019-04-18 13:18:48.576 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 005 Generating anchor peer update

2019-04-18 13:18:48.577 IST [common.tools.configtxgen] doOutputAnchorPeersUpdate -> INFO 006 Writing anchor peer update
+ res=0
+ set +x

+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x
+ peer channel create -o orderer.bankconsortiumbcnet.com:7050 -c chall -f ./channel-artifacts/challchannel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
+ res=0
+ set +x

2019-04-18 07:48:48.883 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:48:48.899 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:48:48.902 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:48:49.047 UTC [cli.common] readBlock -> INFO 004 Received block: 0

===================== Channel "chall" is created successfully ===================== 

###########################################################################

############    CHANNEL chall IS CREATED            #######################

###########################################################################


-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add exsisting org to channel in which it not present.
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addOrgToChannel.sh chall pnb**

Installing jq

Get:1 http://security.ubuntu.com/ubuntu xenial-security InRelease [109 kB]

Hit:2 http://archive.ubuntu.com/ubuntu xenial InRelease

Get:3 http://archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]

Get:4 http://security.ubuntu.com/ubuntu xenial-security/universe Sources [128 kB]

Get:5 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [816 kB]


Get:6 http://archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]

Get:7 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 Packages [551 kB]

Get:8 http://archive.ubuntu.com/ubuntu xenial-updates/universe Sources [319 kB]

Get:9 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 Packages [6121 B]

Get:10 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [1212 kB]

Get:11 http://archive.ubuntu.com/ubuntu xenial-updates/restricted amd64 Packages [13.1 kB]

Get:12 http://archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [962 kB]

Get:13 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 Packages [19.1 kB]

Fetched 4353 kB in 5s (746 kB/s)

Reading package lists...

Reading package lists...

Building dependency tree...

Reading state information...

jq is already the newest version (1.5+dfsg-1ubuntu0.1).

0 upgraded, 0 newly installed, 0 to remove and 92 not upgraded.

Fetching the most recent configuration block for the channel
+ peer channel fetch config config_block.pb -o orderer.bankconsortiumbcnet.com:7050 -c chall --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 07:50:04.842 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:04.861 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable


2019-04-18 07:50:04.865 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:50:04.867 UTC [cli.common] readBlock -> INFO 004 Received block: 0

2019-04-18 07:50:04.869 UTC [cli.common] readBlock -> INFO 005 Received block: 0


Decoding config block to JSON and isolating config to  config.json
+ set +x
+ configtxlator proto_decode --input config_block.pb --type common.Block
+ jq '.data.data[0].payload.data.config'
+ set +x
+ jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"pnbMSP":.[1]}}}}}' config.json ./channel-artifacts/pnb.json
+ set +x
+ configtxlator proto_encode --input config.json --type common.Config
+ configtxlator proto_encode --input modified_config.json --type common.Config
+ configtxlator compute_update --channel_id chall --original original_config.pb --updated modified_config.pb
+ configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate
+ jq .
++ cat config_update.json
+ echo '{"payload":{"header":{"channel_header":{"channel_id":"chall", "type":2}},"data":{"config_update":{' '"channel_id":' '"chall",' '"isolated_data":' '{},' '"read_set":' '{' '"groups":' '{' '"Application":' '{' '"groups":' '{' '"sbiMSP":' '{' '"groups":' '{},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '}' '},' '"mod_policy":' '"",' '"policies":' '{' '"Admins":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Readers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Writers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '}' '},' '"values":' '{},' '"version":' '"1"' '}' '},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '},' '"write_set":' '{' '"groups":' '{' '"Application":' '{' '"groups":' '{' '"pnbMSP":' '{' '"groups":' '{},' '"mod_policy":' '"Admins",' '"policies":' '{' '"Admins":' '{' '"mod_policy":' '"Admins",' '"policy":' '{' '"type":' 1, '"value":' '{' '"identities":' '[' '{' '"principal":' '{' '"msp_identifier":' '"pnbMSP",' '"role":' '"ADMIN"' '},' '"principal_classification":' '"ROLE"' '}' '],' '"rule":' '{' '"n_out_of":' '{' '"n":' 1, '"rules":' '[' '{' '"signed_by":' 0 '}' ']' '}' '},' '"version":' 0 '}' '},' '"version":' '"0"' '},' '"Readers":' '{' '"mod_policy":' '"Admins",' '"policy":' '{' '"type":' 1, '"value":' '{' '"identities":' '[' '{' '"principal":' '{' '"msp_identifier":' '"pnbMSP",' '"role":' '"MEMBER"' '},' '"principal_classification":' '"ROLE"' '}' '],' '"rule":' '{' '"n_out_of":' '{' '"n":' 1, '"rules":' '[' '{' '"signed_by":' 0 '}' ']' '}' '},' '"version":' 0 '}' '},' '"version":' '"0"' '},' '"Writers":' '{' '"mod_policy":' '"Admins",' '"policy":' '{' '"type":' 1, '"value":' '{' '"identities":' '[' '{' '"principal":' '{' '"msp_identifier":' '"pnbMSP",' '"role":' '"MEMBER"' '},' '"principal_classification":' '"ROLE"' '}' '],' '"rule":' '{' '"n_out_of":' '{' '"n":' 1, '"rules":' '[' '{' '"signed_by":' 0 '}' ']' '}' '},' '"version":' 0 '}' '},' '"version":' '"0"' '}' '},' '"values":' '{' '"MSP":' '{' '"mod_policy":' '"Admins",' '"value":' '{' '"config":' '{' '"admins":' '[' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNTekNDQWZLZ0F3SUJBZ0lRU1R5UVZDajlCMWFqWUs2QnhhYU1RREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dkekVMTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVApDa05oYkdsbWIzSnVhV0V4RmpBVUJnTlZCQWNURFZOaGJpQkdjbUZ1WTJselkyOHhEekFOQmdOVkJBc1RCbU5zCmFXVnVkREVxTUNnR0ExVUVBd3doUVdSdGFXNUFjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXQKTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFQ3c2ZHdaZ2pqcy95amFRKzNDVXF4YlZuWG5FUgoraWVZUDlIK29xMDU2KzdQam5ScWhGcmRWVjdRbUxrOTBVam92YkxwUGMwZ2RLQ0thRFI0aEloaFRxTk5NRXN3CkRnWURWUjBQQVFIL0JBUURBZ2VBTUF3R0ExVWRFd0VCL3dRQ01BQXdLd1lEVlIwakJDUXdJb0FnRWU1cSswa3kKWTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnZU5uTgpMZjB4RmpsZWdpK24rSzFSaWkzdXZFSndOSU1oM2lZaFZ3M0pTaW9DSUh4ekRJZ1Jxdyt1ZUlmZUtkK3JjeVNQClpwdkNqeG0zUGVuWVhxTXpLeHdYCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"' '],' '"crypto_config":' '{' '"identity_identifier_hash_function":' '"SHA256",' '"signature_hash_family":' '"SHA2"' '},' '"fabric_node_ous":' '{' '"client_ou_identifier":' '{' '"certificate":' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNmekNDQWlXZ0F3SUJBZ0lRWlY3T0YvYzN3MUEyM2o3S3RCVFZmREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dnWWt4Q3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSQpFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVFlXNGdSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3CmJtSXVZbUZ1YTJOdmJuTnZjblJwZFcxaVkyNWxkQzVqYjIweEp6QWxCZ05WQkFNVEhtTmhMbkJ1WWk1aVlXNXIKWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRCWk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkJDVAp6clRuclpiWVZUZzFGMXZpc25YclVVNzl3c3h3cm0vdGJ4NzJmc0pQWmRheEVENUMzTmZScmRwNHdXVnVBUkc2CmtTYW5YdE5SY29lMExjaE9TVUNqYlRCck1BNEdBMVVkRHdFQi93UUVBd0lCcGpBZEJnTlZIU1VFRmpBVUJnZ3IKQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnRWU1cQorMGt5WTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloCkFLODQ0Q2d5ZEJvWjMvYnlSN2FUaXNvK2JKZFlDMGVLTXljZFhwU0VhUitSQWlCSkRSZ1dEM2l1aTVEb3VabkMKc2k0WkRqbWNQUlhacVJ1WlozcXZhWXBVZlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",' '"organizational_unit_identifier":' '"client"' '},' '"enable":' true, '"peer_ou_identifier":' '{' '"certificate":' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNmekNDQWlXZ0F3SUJBZ0lRWlY3T0YvYzN3MUEyM2o3S3RCVFZmREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dnWWt4Q3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSQpFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVFlXNGdSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3CmJtSXVZbUZ1YTJOdmJuTnZjblJwZFcxaVkyNWxkQzVqYjIweEp6QWxCZ05WQkFNVEhtTmhMbkJ1WWk1aVlXNXIKWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRCWk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkJDVAp6clRuclpiWVZUZzFGMXZpc25YclVVNzl3c3h3cm0vdGJ4NzJmc0pQWmRheEVENUMzTmZScmRwNHdXVnVBUkc2CmtTYW5YdE5SY29lMExjaE9TVUNqYlRCck1BNEdBMVVkRHdFQi93UUVBd0lCcGpBZEJnTlZIU1VFRmpBVUJnZ3IKQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnRWU1cQorMGt5WTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloCkFLODQ0Q2d5ZEJvWjMvYnlSN2FUaXNvK2JKZFlDMGVLTXljZFhwU0VhUitSQWlCSkRSZ1dEM2l1aTVEb3VabkMKc2k0WkRqbWNQUlhacVJ1WlozcXZhWXBVZlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",' '"organizational_unit_identifier":' '"peer"' '}' '},' '"intermediate_certs":' '[],' '"name":' '"pnbMSP",' '"organizational_unit_identifiers":' '[],' '"revocation_list":' '[],' '"root_certs":' '[' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNmekNDQWlXZ0F3SUJBZ0lRWlY3T0YvYzN3MUEyM2o3S3RCVFZmREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dnWWt4Q3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSQpFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVFlXNGdSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3CmJtSXVZbUZ1YTJOdmJuTnZjblJwZFcxaVkyNWxkQzVqYjIweEp6QWxCZ05WQkFNVEhtTmhMbkJ1WWk1aVlXNXIKWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRCWk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkJDVAp6clRuclpiWVZUZzFGMXZpc25YclVVNzl3c3h3cm0vdGJ4NzJmc0pQWmRheEVENUMzTmZScmRwNHdXVnVBUkc2CmtTYW5YdE5SY29lMExjaE9TVUNqYlRCck1BNEdBMVVkRHdFQi93UUVBd0lCcGpBZEJnTlZIU1VFRmpBVUJnZ3IKQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnRWU1cQorMGt5WTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloCkFLODQ0Q2d5ZEJvWjMvYnlSN2FUaXNvK2JKZFlDMGVLTXljZFhwU0VhUitSQWlCSkRSZ1dEM2l1aTVEb3VabkMKc2k0WkRqbWNQUlhacVJ1WlozcXZhWXBVZlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="' '],' '"signing_identity":' null, '"tls_intermediate_certs":' '[],' '"tls_root_certs":' '[' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNoakNDQWl5Z0F3SUJBZ0lSQUpZRlF0aDBzdXA5MWNuK1V6SERoRlF3Q2dZSUtvWkl6ajBFQXdJd2dZd3gKQ3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSUV3cERZV3hwWm05eWJtbGhNUll3RkFZRFZRUUhFdzFUWVc0ZwpSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3Ym1JdVltRnVhMk52Ym5OdmNuUnBkVzFpWTI1bGRDNWpiMjB4CktqQW9CZ05WQkFNVElYUnNjMk5oTG5CdVlpNWlZVzVyWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRBZUZ3MHgKT1RBME1UZ3dOekU1TURCYUZ3MHlPVEEwTVRVd056RTVNREJhTUlHTU1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFRwpBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeVlXNWphWE5qYnpFa01DSUdBMVVFCkNoTWJjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNU293S0FZRFZRUURFeUYwYkhOallTNXcKYm1JdVltRnVhMk52Ym5OdmNuUnBkVzFpWTI1bGRDNWpiMjB3V1RBVEJnY3Foa2pPUFFJQkJnZ3Foa2pPUFFNQgpCd05DQUFSREQwVHBvMFNUcnA4Wk9XMHN4WlR0SXVIbXNHOFdBalFmTSs0Q0pPNG1qS3ZjOWROYm5EYnpxQVZuCmROM3N4aHVWUURUUFlnMFVzdC9HUUdSREpRTGxvMjB3YXpBT0JnTlZIUThCQWY4RUJBTUNBYVl3SFFZRFZSMGwKQkJZd0ZBWUlLd1lCQlFVSEF3SUdDQ3NHQVFVRkJ3TUJNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdLUVlEVlIwTwpCQ0lFSUlJcFFaam1ncnlSQlRLYURXTmV4UEdjdEZrWGEvRFk4bFZFTU1oMnJaWkZNQW9HQ0NxR1NNNDlCQU1DCkEwZ0FNRVVDSVFDVENQYXlZY2VJVzM1MWlRY0xFdmllRUVnUExyeStrSnBQTGNKdDFCaEtZUUlnWlhzNnN5TFkKdGFYVmM5ekRuR0RRUkk3aDJvbERqUFpYaHFWaVB2ajd0MlE9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"' ']' '},' '"type":' 0 '},' '"version":' '"0"' '}' '},' '"version":' '"0"' '},' '"sbiMSP":' '{' '"groups":' '{},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '}' '},' '"mod_policy":' '"Admins",' '"policies":' '{' '"Admins":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Readers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Writers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '}' '},' '"values":' '{},' '"version":' '"2"' '}' '},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '}' '}}}}'
+ configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope

========= Config transaction to add pnb to network created ===== 

+ set +x
+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x

Signing config transaction

+ peer channel signconfigtx -f pnb_update_in_envelope.pb

2019-04-18 07:50:05.765 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:05.805 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:05.805 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized
+ set +x

========= Submitting transaction from a different peer (peer0.pnb) which also signs it ========= 

+ peer channel update -f pnb_update_in_envelope.pb -c chall -o orderer.bankconsortiumbcnet.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 07:50:05.850 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:05.867 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:05.870 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:50:05.885 UTC [channelCmd] update -> INFO 004 Successfully submitted channel update

+ set +x
========= Config transaction to add pnb to network submitted! =========== 

+ CORE_PEER_LOCALMSPID=pnbMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/peers/peer0.pnb.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/users/Admin@pnb.bankconsortiumbcnet.com/msp
+ set +x

Fetching channel config block from orderer...

+ CORE_PEER_ADDRESS=peer0.pnb.bankconsortiumbcnet.com:7121
+ set +x
+ peer channel fetch 0 chall.block -o orderer.bankconsortiumbcnet.com:7050 -c chall --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 07:50:11.228 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:11.264 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:50:11.268 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:50:11.271 UTC [cli.common] readBlock -> INFO 004 Received block: 0
+ set +x

##################################################################

############   pnb is added to CHANNEL chall  ####################

##################################################################

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ls**

addnewpeer.sh           configtx-file-gen.sh  cryptogeneration.sh               hdfc                   operations.py          scripts

addOrgToChannel.sh      configtx.yaml         docker-compose-e2e-pnb.yaml       icici                  pnb                    tempfile.sh

base                    createChannel.sh      docker-compose-e2e-template.yaml  joinchannel.sh         README.md              tempFolder

bcnetsetup.sh           createNewChannel.sh   docker-compose-e2e.yaml           network-configuration  replaceprivatekeys.sh

channel-artifacts       crypto-config         firstnetwork.sh                   newChannelFiles        resetFolder.sh

channelartifactsgen.sh  crypto-config.yaml    firstnetworkup.sh                 newOrgAddtion.sh       sbi

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to join channel by peer of an org
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./joinchannel.sh 0 pnb chall**

+ CORE_PEER_LOCALMSPID=pnbMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/peers/peer0.pnb.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/users/Admin@pnb.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.pnb.bankconsortiumbcnet.com:7121
+ set +x
+ peer channel join -b chall.block
+ res=0
+ set +x

2019-04-18 07:51:31.366 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:51:31.382 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:51:31.385 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:51:31.976 UTC [channelCmd] executeJoin -> INFO 004 Successfully submitted proposal to join channel

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add exsisting org to channel in which it not present.
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addOrgToChannel.sh chall sbi**

Installing jq

Hit:1 http://archive.ubuntu.com/ubuntu xenial InRelease

Hit:2 http://security.ubuntu.com/ubuntu xenial-security InRelease

Hit:3 http://archive.ubuntu.com/ubuntu xenial-updates InRelease

Hit:4 http://archive.ubuntu.com/ubuntu xenial-backports InRelease

Reading package lists...

Reading package lists...

Building dependency tree...

Reading state information...

jq is already the newest version (1.5+dfsg-1ubuntu0.1).

0 upgraded, 0 newly installed, 0 to remove and 92 not upgraded.


Fetching the most recent configuration block for the channel
+ peer channel fetch config config_block.pb -o orderer.bankconsortiumbcnet.com:7050 -c chall --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 07:52:10.738 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:10.754 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:10.758 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:52:10.762 UTC [cli.common] readBlock -> INFO 004 Received block: 1

2019-04-18 07:52:10.789 UTC [cli.common] readBlock -> INFO 005 Received block: 1
+ set +x

Decoding config block to JSON and isolating config to  config.json
+ configtxlator proto_decode --input config_block.pb --type common.Block
+ jq '.data.data[0].payload.data.config'
+ set +x
+ jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"sbiMSP":.[1]}}}}}' config.json ./channel-artifacts/sbi.json
+ set +x
+ configtxlator proto_encode --input config.json --type common.Config
+ configtxlator proto_encode --input modified_config.json --type common.Config
+ configtxlator compute_update --channel_id chall --original original_config.pb --updated modified_config.pb
configtxlator: error: Error computing update: error computing config update: no differences detected between original and updated config
+ configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate
+ jq .
++ cat config_update.json
+ echo '{"payload":{"header":{"channel_header":{"channel_id":"chall", "type":2}},"data":{"config_update":{' '"channel_id":' '"",' '"isolated_data":' '{},' '"read_set":' null, '"write_set":' null '}}}}'
+ configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope
+ set +x

========= Config transaction to add sbi to network created ===== 

+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x

Signing config transaction by sbi

+ peer channel signconfigtx -f sbi_update_in_envelope.pb

2019-04-18 07:52:11.167 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:11.183 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:11.183 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized
+ set +x
+ CORE_PEER_LOCALMSPID=pnbMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/peers/peer0.pnb.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/users/Admin@pnb.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.pnb.bankconsortiumbcnet.com:7121
+ set +x

Signing config transaction

+ peer channel signconfigtx -f sbi_update_in_envelope.pb

2019-04-18 07:52:11.228 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:11.261 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:11.261 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

========= Submitting transaction from a different peer (peer0.sbi) which also signs it ========= 

+ set +x
+ peer channel update -f sbi_update_in_envelope.pb -c chall -o orderer.bankconsortiumbcnet.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 07:52:11.302 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:11.321 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:11.325 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

Error: got unexpected status: BAD_REQUEST -- error authorizing update: ConfigUpdate for channel '' but envelope for channel 'chall'
+ set +x
+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x
+ peer channel fetch 0 chall.block -o orderer.bankconsortiumbcnet.com:7050 -c chall --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
Fetching channel config block from orderer...

2019-04-18 07:52:13.652 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:13.668 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:52:13.672 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:52:13.675 UTC [cli.common] readBlock -> INFO 004 Received block: 0
+ set +x

########################################################################

#############    sbi is added to CHANNEL chall    ######################

########################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to join channel by peer of an org
-----------------------------------------------------------------------------------------------------------------------------

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./joinchannel.sh 0 sbi chall**

+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x
+ peer channel join -b chall.block
+ res=0
+ set +x

2019-04-18 07:53:13.881 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:53:13.897 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 07:53:13.901 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 07:53:14.305 UTC [channelCmd] executeJoin -> INFO 004 Successfully submitted proposal to join channel

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add exsisting org to channel in which it not present.
-----------------------------------------------------------------------------------------------------------------------------
**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addOrgToChannel.sh chsbihdfc pnb** 

Installing jq

Get:1 http://security.ubuntu.com/ubuntu xenial-security InRelease [109 kB]

Hit:2 http://archive.ubuntu.com/ubuntu xenial InRelease

Get:3 http://archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]

Get:4 http://archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]

Fetched 325 kB in 5s (62.4 kB/s)

Reading package lists...

Reading package lists...

Building dependency tree...

Reading state information...

jq is already the newest version (1.5+dfsg-1ubuntu0.1).

0 upgraded, 0 newly installed, 0 to remove and 92 not upgraded.

Fetching the most recent configuration block for the channel
+ peer channel fetch config config_block.pb -o orderer.bankconsortiumbcnet.com:7050 -c chsbihdfc --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 09:49:23.760 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:23.776 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:23.780 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 09:49:23.786 UTC [cli.common] readBlock -> INFO 004 Received block: 0

2019-04-18 09:49:23.788 UTC [cli.common] readBlock -> INFO 005 Received block: 0
+ set +x

Decoding config block to JSON and isolating config to  config.json
+ configtxlator proto_decode --input config_block.pb --type common.Block
+ jq '.data.data[0].payload.data.config'
+ set +x
+ jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"pnbMSP":.[1]}}}}}' config.json ./channel-artifacts/pnb.json
+ set +x
+ configtxlator proto_encode --input config.json --type common.Config
+ configtxlator proto_encode --input modified_config.json --type common.Config
+ configtxlator compute_update --channel_id chsbihdfc --original original_config.pb --updated modified_config.pb
+ configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate
+ jq .
++ cat config_update.json
+ echo '{"payload":{"header":{"channel_header":{"channel_id":"chsbihdfc", "type":2}},"data":{"config_update":{' '"channel_id":' '"chsbihdfc",' '"isolated_data":' '{},' '"read_set":' '{' '"groups":' '{' '"Application":' '{' '"groups":' '{' '"hdfcMSP":' '{' '"groups":' '{},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '},' '"sbiMSP":' '{' '"groups":' '{},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '}' '},' '"mod_policy":' '"",' '"policies":' '{' '"Admins":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Readers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Writers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '}' '},' '"values":' '{},' '"version":' '"1"' '}' '},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '},' '"write_set":' '{' '"groups":' '{' '"Application":' '{' '"groups":' '{' '"hdfcMSP":' '{' '"groups":' '{},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '},' '"pnbMSP":' '{' '"groups":' '{},' '"mod_policy":' '"Admins",' '"policies":' '{' '"Admins":' '{' '"mod_policy":' '"Admins",' '"policy":' '{' '"type":' 1, '"value":' '{' '"identities":' '[' '{' '"principal":' '{' '"msp_identifier":' '"pnbMSP",' '"role":' '"ADMIN"' '},' '"principal_classification":' '"ROLE"' '}' '],' '"rule":' '{' '"n_out_of":' '{' '"n":' 1, '"rules":' '[' '{' '"signed_by":' 0 '}' ']' '}' '},' '"version":' 0 '}' '},' '"version":' '"0"' '},' '"Readers":' '{' '"mod_policy":' '"Admins",' '"policy":' '{' '"type":' 1, '"value":' '{' '"identities":' '[' '{' '"principal":' '{' '"msp_identifier":' '"pnbMSP",' '"role":' '"MEMBER"' '},' '"principal_classification":' '"ROLE"' '}' '],' '"rule":' '{' '"n_out_of":' '{' '"n":' 1, '"rules":' '[' '{' '"signed_by":' 0 '}' ']' '}' '},' '"version":' 0 '}' '},' '"version":' '"0"' '},' '"Writers":' '{' '"mod_policy":' '"Admins",' '"policy":' '{' '"type":' 1, '"value":' '{' '"identities":' '[' '{' '"principal":' '{' '"msp_identifier":' '"pnbMSP",' '"role":' '"MEMBER"' '},' '"principal_classification":' '"ROLE"' '}' '],' '"rule":' '{' '"n_out_of":' '{' '"n":' 1, '"rules":' '[' '{' '"signed_by":' 0 '}' ']' '}' '},' '"version":' 0 '}' '},' '"version":' '"0"' '}' '},' '"values":' '{' '"MSP":' '{' '"mod_policy":' '"Admins",' '"value":' '{' '"config":' '{' '"admins":' '[' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNTekNDQWZLZ0F3SUJBZ0lRU1R5UVZDajlCMWFqWUs2QnhhYU1RREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dkekVMTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVApDa05oYkdsbWIzSnVhV0V4RmpBVUJnTlZCQWNURFZOaGJpQkdjbUZ1WTJselkyOHhEekFOQmdOVkJBc1RCbU5zCmFXVnVkREVxTUNnR0ExVUVBd3doUVdSdGFXNUFjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXQKTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFQ3c2ZHdaZ2pqcy95amFRKzNDVXF4YlZuWG5FUgoraWVZUDlIK29xMDU2KzdQam5ScWhGcmRWVjdRbUxrOTBVam92YkxwUGMwZ2RLQ0thRFI0aEloaFRxTk5NRXN3CkRnWURWUjBQQVFIL0JBUURBZ2VBTUF3R0ExVWRFd0VCL3dRQ01BQXdLd1lEVlIwakJDUXdJb0FnRWU1cSswa3kKWTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnZU5uTgpMZjB4RmpsZWdpK24rSzFSaWkzdXZFSndOSU1oM2lZaFZ3M0pTaW9DSUh4ekRJZ1Jxdyt1ZUlmZUtkK3JjeVNQClpwdkNqeG0zUGVuWVhxTXpLeHdYCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"' '],' '"crypto_config":' '{' '"identity_identifier_hash_function":' '"SHA256",' '"signature_hash_family":' '"SHA2"' '},' '"fabric_node_ous":' '{' '"client_ou_identifier":' '{' '"certificate":' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNmekNDQWlXZ0F3SUJBZ0lRWlY3T0YvYzN3MUEyM2o3S3RCVFZmREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dnWWt4Q3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSQpFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVFlXNGdSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3CmJtSXVZbUZ1YTJOdmJuTnZjblJwZFcxaVkyNWxkQzVqYjIweEp6QWxCZ05WQkFNVEhtTmhMbkJ1WWk1aVlXNXIKWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRCWk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkJDVAp6clRuclpiWVZUZzFGMXZpc25YclVVNzl3c3h3cm0vdGJ4NzJmc0pQWmRheEVENUMzTmZScmRwNHdXVnVBUkc2CmtTYW5YdE5SY29lMExjaE9TVUNqYlRCck1BNEdBMVVkRHdFQi93UUVBd0lCcGpBZEJnTlZIU1VFRmpBVUJnZ3IKQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnRWU1cQorMGt5WTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloCkFLODQ0Q2d5ZEJvWjMvYnlSN2FUaXNvK2JKZFlDMGVLTXljZFhwU0VhUitSQWlCSkRSZ1dEM2l1aTVEb3VabkMKc2k0WkRqbWNQUlhacVJ1WlozcXZhWXBVZlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",' '"organizational_unit_identifier":' '"client"' '},' '"enable":' true, '"peer_ou_identifier":' '{' '"certificate":' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNmekNDQWlXZ0F3SUJBZ0lRWlY3T0YvYzN3MUEyM2o3S3RCVFZmREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dnWWt4Q3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSQpFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVFlXNGdSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3CmJtSXVZbUZ1YTJOdmJuTnZjblJwZFcxaVkyNWxkQzVqYjIweEp6QWxCZ05WQkFNVEhtTmhMbkJ1WWk1aVlXNXIKWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRCWk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkJDVAp6clRuclpiWVZUZzFGMXZpc25YclVVNzl3c3h3cm0vdGJ4NzJmc0pQWmRheEVENUMzTmZScmRwNHdXVnVBUkc2CmtTYW5YdE5SY29lMExjaE9TVUNqYlRCck1BNEdBMVVkRHdFQi93UUVBd0lCcGpBZEJnTlZIU1VFRmpBVUJnZ3IKQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnRWU1cQorMGt5WTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloCkFLODQ0Q2d5ZEJvWjMvYnlSN2FUaXNvK2JKZFlDMGVLTXljZFhwU0VhUitSQWlCSkRSZ1dEM2l1aTVEb3VabkMKc2k0WkRqbWNQUlhacVJ1WlozcXZhWXBVZlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",' '"organizational_unit_identifier":' '"peer"' '}' '},' '"intermediate_certs":' '[],' '"name":' '"pnbMSP",' '"organizational_unit_identifiers":' '[],' '"revocation_list":' '[],' '"root_certs":' '[' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNmekNDQWlXZ0F3SUJBZ0lRWlY3T0YvYzN3MUEyM2o3S3RCVFZmREFLQmdncWhrak9QUVFEQWpDQmlURUwKTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdWFXRXhGakFVQmdOVkJBY1REVk5oYmlCRwpjbUZ1WTJselkyOHhKREFpQmdOVkJBb1RHM0J1WWk1aVlXNXJZMjl1YzI5eWRHbDFiV0pqYm1WMExtTnZiVEVuCk1DVUdBMVVFQXhNZVkyRXVjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNQjRYRFRFNU1EUXgKT0RBM01Ua3dNRm9YRFRJNU1EUXhOVEEzTVRrd01Gb3dnWWt4Q3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSQpFd3BEWVd4cFptOXlibWxoTVJZd0ZBWURWUVFIRXcxVFlXNGdSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3CmJtSXVZbUZ1YTJOdmJuTnZjblJwZFcxaVkyNWxkQzVqYjIweEp6QWxCZ05WQkFNVEhtTmhMbkJ1WWk1aVlXNXIKWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRCWk1CTUdCeXFHU000OUFnRUdDQ3FHU000OUF3RUhBMElBQkJDVAp6clRuclpiWVZUZzFGMXZpc25YclVVNzl3c3h3cm0vdGJ4NzJmc0pQWmRheEVENUMzTmZScmRwNHdXVnVBUkc2CmtTYW5YdE5SY29lMExjaE9TVUNqYlRCck1BNEdBMVVkRHdFQi93UUVBd0lCcGpBZEJnTlZIU1VFRmpBVUJnZ3IKQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3RHdZRFZSMFRBUUgvQkFVd0F3RUIvekFwQmdOVkhRNEVJZ1FnRWU1cQorMGt5WTUwR2hSSTczSVo4VFNoZG5EdW9TcENzditubTQrMDdnaFl3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloCkFLODQ0Q2d5ZEJvWjMvYnlSN2FUaXNvK2JKZFlDMGVLTXljZFhwU0VhUitSQWlCSkRSZ1dEM2l1aTVEb3VabkMKc2k0WkRqbWNQUlhacVJ1WlozcXZhWXBVZlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="' '],' '"signing_identity":' null, '"tls_intermediate_certs":' '[],' '"tls_root_certs":' '[' '"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNoakNDQWl5Z0F3SUJBZ0lSQUpZRlF0aDBzdXA5MWNuK1V6SERoRlF3Q2dZSUtvWkl6ajBFQXdJd2dZd3gKQ3pBSkJnTlZCQVlUQWxWVE1STXdFUVlEVlFRSUV3cERZV3hwWm05eWJtbGhNUll3RkFZRFZRUUhFdzFUWVc0ZwpSbkpoYm1OcGMyTnZNU1F3SWdZRFZRUUtFeHR3Ym1JdVltRnVhMk52Ym5OdmNuUnBkVzFpWTI1bGRDNWpiMjB4CktqQW9CZ05WQkFNVElYUnNjMk5oTG5CdVlpNWlZVzVyWTI5dWMyOXlkR2wxYldKamJtVjBMbU52YlRBZUZ3MHgKT1RBME1UZ3dOekU1TURCYUZ3MHlPVEEwTVRVd056RTVNREJhTUlHTU1Rc3dDUVlEVlFRR0V3SlZVekVUTUJFRwpBMVVFQ0JNS1EyRnNhV1p2Y201cFlURVdNQlFHQTFVRUJ4TU5VMkZ1SUVaeVlXNWphWE5qYnpFa01DSUdBMVVFCkNoTWJjRzVpTG1KaGJtdGpiMjV6YjNKMGFYVnRZbU51WlhRdVkyOXRNU293S0FZRFZRUURFeUYwYkhOallTNXcKYm1JdVltRnVhMk52Ym5OdmNuUnBkVzFpWTI1bGRDNWpiMjB3V1RBVEJnY3Foa2pPUFFJQkJnZ3Foa2pPUFFNQgpCd05DQUFSREQwVHBvMFNUcnA4Wk9XMHN4WlR0SXVIbXNHOFdBalFmTSs0Q0pPNG1qS3ZjOWROYm5EYnpxQVZuCmROM3N4aHVWUURUUFlnMFVzdC9HUUdSREpRTGxvMjB3YXpBT0JnTlZIUThCQWY4RUJBTUNBYVl3SFFZRFZSMGwKQkJZd0ZBWUlLd1lCQlFVSEF3SUdDQ3NHQVFVRkJ3TUJNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdLUVlEVlIwTwpCQ0lFSUlJcFFaam1ncnlSQlRLYURXTmV4UEdjdEZrWGEvRFk4bFZFTU1oMnJaWkZNQW9HQ0NxR1NNNDlCQU1DCkEwZ0FNRVVDSVFDVENQYXlZY2VJVzM1MWlRY0xFdmllRUVnUExyeStrSnBQTGNKdDFCaEtZUUlnWlhzNnN5TFkKdGFYVmM5ekRuR0RRUkk3aDJvbERqUFpYaHFWaVB2ajd0MlE9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"' ']' '},' '"type":' 0 '},' '"version":' '"0"' '}' '},' '"version":' '"0"' '},' '"sbiMSP":' '{' '"groups":' '{},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '}' '},' '"mod_policy":' '"Admins",' '"policies":' '{' '"Admins":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Readers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '},' '"Writers":' '{' '"mod_policy":' '"",' '"policy":' null, '"version":' '"0"' '}' '},' '"values":' '{},' '"version":' '"2"' '}' '},' '"mod_policy":' '"",' '"policies":' '{},' '"values":' '{},' '"version":' '"0"' '}' '}}}}'
+ configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope
+ set +x

========= Config transaction to add pnb to network created ===== 

+ CORE_PEER_LOCALMSPID=sbiMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101
+ set +x

Signing config transaction by pnb

+ peer channel signconfigtx -f pnb_update_in_envelope.pb

2019-04-18 09:49:24.145 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:24.161 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:24.161 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized
+ set +x
+ CORE_PEER_LOCALMSPID=hdfcMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/peers/peer0.hdfc.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/users/Admin@hdfc.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.hdfc.bankconsortiumbcnet.com:7105
+ set +x

Signing config transaction

+ peer channel signconfigtx -f pnb_update_in_envelope.pb

2019-04-18 09:49:24.203 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:24.220 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:24.220 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized
+ set +x

========= Submitting transaction from a different peer (peer0.pnb) which also signs it ========= 

+ peer channel update -f pnb_update_in_envelope.pb -c chsbihdfc -o orderer.bankconsortiumbcnet.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 09:49:24.261 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:24.278 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:24.281 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 09:49:24.295 UTC [channelCmd] update -> INFO 004 Successfully submitted channel update
+ set +x

Fetching channel config block from orderer...
+ CORE_PEER_LOCALMSPID=pnbMSP
+ CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/peers/peer0.pnb.bankconsortiumbcnet.com/tls/ca.crt
+ CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/users/Admin@pnb.bankconsortiumbcnet.com/msp
+ set +x
+ CORE_PEER_ADDRESS=peer0.pnb.bankconsortiumbcnet.com:7121
+ set +x
+ peer channel fetch 0 chsbihdfc.block -o orderer.bankconsortiumbcnet.com:7050 -c chsbihdfc --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem

2019-04-18 09:49:26.648 UTC [main] InitCmd -> WARN 001 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:26.665 UTC [main] SetOrdererEnv -> WARN 002 CORE_LOGGING_LEVEL is no longer supported, please use the FABRIC_LOGGING_SPEC environment variable

2019-04-18 09:49:26.669 UTC [channelCmd] InitCmdFactory -> INFO 003 Endorser and orderer connections initialized

2019-04-18 09:49:26.673 UTC [cli.common] readBlock -> INFO 004 Received block: 0
+ set +x

#######################################################################

###############    pnb is added to CHANNEL chsbihdfc    ###############

#######################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add new peer to an org in exsisting blockchain network
-----------------------------------------------------------------------------------------------------------------------------

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addnewpeer.sh pnb**

Creating volume "bankconsortiumbcnet_peer2.pnb.bankconsortiumbcnet.com" with default driver

Creating peer2.pnb.bankconsortiumbcnet.com

#########################################################################

#############    New Peer2 is added to pnb        #######################

#########################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add new peer to an org in exsisting blockchain network
-----------------------------------------------------------------------------------------------------------------------------

**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addnewpeer.sh hdfc**

Creating volume "bankconsortiumbcnet_peer3.hdfc.bankconsortiumbcnet.com" with default driver

Creating peer3.hdfc.bankconsortiumbcnet.com

########################################################################

############    New Peer3 is added to hdfc        ######################

########################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                Command to add new peer to an org in exsisting blockchain network
-----------------------------------------------------------------------------------------------------------------------------


**piyushkumar@ubuntu:~/Documents/dynamic-hyperledger-fabric-singlehost-files$ ./addnewpeer.sh icici**

Creating volume "bankconsortiumbcnet_peer4.icici.bankconsortiumbcnet.com" with default driver

Creating peer4.icici.bankconsortiumbcnet.com

#######################################################################

#############    New Peer4 is added to icici     ######################

#######################################################################

-----------------------------------------------------------------------------------------------------------------------------
                                                              END
-----------------------------------------------------------------------------------------------------------------------------
