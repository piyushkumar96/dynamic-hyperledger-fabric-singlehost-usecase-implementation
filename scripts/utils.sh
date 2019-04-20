

setGlobals () {
PEER=$1
ORG=$2
if [ $ORG == "sbi" ] ; then
          set -x
          CORE_PEER_LOCALMSPID="sbiMSP"
          CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/peers/peer0.sbi.bankconsortiumbcnet.com/tls/ca.crt
          CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.bankconsortiumbcnet.com/users/Admin@sbi.bankconsortiumbcnet.com/msp
          set +x
          if [ $PEER -eq 0 ]; then
            set -x
            CORE_PEER_ADDRESS=peer0.sbi.bankconsortiumbcnet.com:7101 
            set +x
          elif [ $PEER -eq 1 ]; then
            set -x
            CORE_PEER_ADDRESS=peer1.sbi.bankconsortiumbcnet.com:7101
            set +x
          elif [ $PEER -eq 2 ]; then 
           set -x 
           CORE_PEER_ADDRESS=peer2.sbi.bankconsortiumbcnet.com:7101 
           set +x 
#newpeersbi
          fi
elif [ $ORG == "hdfc" ] ; then
          set -x
          CORE_PEER_LOCALMSPID="hdfcMSP"
          CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/peers/peer0.hdfc.bankconsortiumbcnet.com/tls/ca.crt
          CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdfc.bankconsortiumbcnet.com/users/Admin@hdfc.bankconsortiumbcnet.com/msp
          set +x
          if [ $PEER -eq 0 ]; then
            set -x
            CORE_PEER_ADDRESS=peer0.hdfc.bankconsortiumbcnet.com:7105 
            set +x
          elif [ $PEER -eq 1 ]; then
            set -x
            CORE_PEER_ADDRESS=peer1.hdfc.bankconsortiumbcnet.com:7105
            set +x
          elif [ $PEER -eq 2 ]; then
            set -x
            CORE_PEER_ADDRESS=peer2.hdfc.bankconsortiumbcnet.com:7105
            set +x
#newpeerhdfc
          fi
elif [ $ORG == "icici" ] ; then
          set -x
          CORE_PEER_LOCALMSPID="iciciMSP"
          CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.bankconsortiumbcnet.com/peers/peer0.icici.bankconsortiumbcnet.com/tls/ca.crt
          CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.bankconsortiumbcnet.com/users/Admin@icici.bankconsortiumbcnet.com/msp
          set +x
          if [ $PEER -eq 0 ]; then
            set -x
            CORE_PEER_ADDRESS=peer0.icici.bankconsortiumbcnet.com:7111 
            set +x
          elif [ $PEER -eq 1 ]; then
            set -x
            CORE_PEER_ADDRESS=peer1.icici.bankconsortiumbcnet.com:7111
            set +x
          elif [ $PEER -eq 2 ]; then
            set -x
            CORE_PEER_ADDRESS=peer2.icici.bankconsortiumbcnet.com:7111
            set +x
          elif [ $PEER -eq 3 ]; then
            set -x
            CORE_PEER_ADDRESS=peer3.icici.bankconsortiumbcnet.com:7111
            set +x
#newpeericici
          fi
elif [ $ORG == "pnb" ] ; then
          set -x
          CORE_PEER_LOCALMSPID="pnbMSP"
          CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/peers/peer0.pnb.bankconsortiumbcnet.com/tls/ca.crt
          CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pnb.bankconsortiumbcnet.com/users/Admin@pnb.bankconsortiumbcnet.com/msp
          set +x
          if [ $PEER -eq 0 ]; then
            set -x
            CORE_PEER_ADDRESS=peer0.pnb.bankconsortiumbcnet.com:7121
            set +x
          elif [ $PEER -eq 1 ]; then
            set -x
            CORE_PEER_ADDRESS=peer1.pnb.bankconsortiumbcnet.com:7121
            set +x
#newpeerpnb
          fi
#neworg
else
		echo "================== ERROR !!! ORG Unknown =================="
fi

}


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
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/users/Admin@bankconsortiumbcnet.com/msp
}

createChannel() {
        
        setGlobals $1 $2
        
        if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
                      set -x
          peer channel create -o orderer.bankconsortiumbcnet.com:7050 -c $3 -f ./channel-artifacts/$3channel.tx >&log.txt
          res=$?
                      set +x
        else
              set -x
          peer channel create -o orderer.bankconsortiumbcnet.com:7050 -c $3 -f ./channel-artifacts/$3channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem >&log.txt
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




