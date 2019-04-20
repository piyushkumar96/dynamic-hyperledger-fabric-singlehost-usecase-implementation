#!/bin/bash
        
    # import utils
    . scripts/utils.sh
    
    # setting peer0 of pnb environment variables
    setGlobals 0 pnb
    
    echo "Fetching channel config block from orderer..."
    set -x
    peer channel fetch 0 chsbihdfc.block -o orderer.bankconsortiumbcnet.com:7050 -c chsbihdfc --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
    set +x 
