#!/bin/bash
    
    echo "Installing jq"
    apt-get -y update && apt-get -y install jq
    
    # import utils
    . scripts/utils.sh

    # setting orderer environment variables
    setOrdererGlobals
    
    # Fetch the config for the channel, writing it to config.json
    echo "Fetching the most recent configuration block for the channel"
    set -x
    peer channel fetch config config_block.pb  -o orderer.bankconsortiumbcnet.com:7050 -c chsbihdfc --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
    set +x
    
    echo "Decoding config block to JSON and isolating config to  "config.json""
    set -x
    configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > "config.json"
    set +x
    
    # Modify the configuration to append the new org
    set -x
    jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"pnbMSP":.[1]}}}}}' config.json ./channel-artifacts/pnb.json > modified_config.json
    set +x

    # Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to org3_update_in_envelope.pb
    set -x
    configtxlator proto_encode --input config.json --type common.Config > original_config.pb

    configtxlator proto_encode --input modified_config.json --type common.Config > modified_config.pb

    configtxlator compute_update --channel_id chsbihdfc --original original_config.pb --updated modified_config.pb > config_update.pb

    configtxlator proto_decode --input config_update.pb  --type common.ConfigUpdate > config_update.json

    echo '{"payload":{"header":{"channel_header":{"channel_id":"chsbihdfc", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json

    configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope > pnb_update_in_envelope.pb
    set +x

    echo
    echo "========= Config transaction to add pnb to network created ===== "
    echo
    
    # import utils
    . scripts/utils.sh
setGlobals 0 sbi
        echo "Signing config transaction by pnb"
        echo
        set -x
        peer channel signconfigtx -f pnb_update_in_envelope.pb
        set +x

        # setting peer0 of pnb environment variables
        setGlobals 0 hdfc
        echo "Signing config transaction"
        echo
        set -x
        peer channel signconfigtx -f pnb_update_in_envelope.pb
        set +x

        echo
        echo "========= Submitting transaction from a different peer (peer0.pnb) which also signs it ========= "
        echo
        set -x
        peer channel update -f pnb_update_in_envelope.pb -c chsbihdfc -o orderer.bankconsortiumbcnet.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/bankconsortiumbcnet.com/orderers/orderer.bankconsortiumbcnet.com/msp/tlscacerts/tlsca.bankconsortiumbcnet.com-cert.pem
        set +x
set -x
