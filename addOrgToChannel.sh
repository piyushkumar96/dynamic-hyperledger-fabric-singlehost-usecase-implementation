#!/bin/bash

channelname=$1
orgname=$2
nameofnetwork=$(python operations.py getNetworkName)
nooforgsinchannel=$(python operations.py getChannelOrgCount $channelname)

if [ $nooforgsinchannel == "1" ]; then
    org1inchannel=$(python operations.py getOrgFromChannel $channelname 0 )

    echo -e '#!/bin/bash
    
    echo "Installing jq"
    apt-get -y update && apt-get -y install jq
    
    # import utils
    . scripts/utils.sh

    # setting orderer environment variables
    setOrdererGlobals
    
    # Fetch the config for the channel, writing it to config.json
    echo "Fetching the most recent configuration block for the channel"
    set -x
    peer channel fetch config config_block.pb  -o orderer.'$nameofnetwork'.com:7050 -c '$channelname' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem
    set +x
    
    echo "Decoding config block to JSON and isolating config to  "config.json""
    set -x
    configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > "config.json"
    set +x
    
    # Modify the configuration to append the new org
    set -x
    jq -s '\''.[0] * {"channel_group":{"groups":{"Application":{"groups": {"'$orgname'MSP":.[1]}}}}}'\'' config.json ./channel-artifacts/'$orgname'.json > modified_config.json
    set +x

    # Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to org3_update_in_envelope.pb
    set -x
    configtxlator proto_encode --input config.json --type common.Config > original_config.pb

    configtxlator proto_encode --input modified_config.json --type common.Config > modified_config.pb

    configtxlator compute_update --channel_id '$channelname' --original original_config.pb --updated modified_config.pb > config_update.pb

    configtxlator proto_decode --input config_update.pb  --type common.ConfigUpdate > config_update.json

    echo '\''{"payload":{"header":{"channel_header":{"channel_id":"'$channelname'", "type":2}},"data":{"config_update":'\''$(cat config_update.json)'\''}}}'\'' | jq . > config_update_in_envelope.json

    configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope > '$orgname'_update_in_envelope.pb
    set +x

    echo
    echo "========= Config transaction to add '$orgname' to network created ===== "
    echo
    
    # import utils
    . scripts/utils.sh
    
     # setting peer0 of '$orgname' environment variables
    setGlobals 0 '$org1inchannel'

    echo "Signing config transaction"
    echo
    set -x
    peer channel signconfigtx -f '$orgname'_update_in_envelope.pb
    set +x
    
    echo
    echo "========= Submitting transaction from a different peer (peer0.'$orgname') which also signs it ========= "
    echo
    set -x
    peer channel update -f '$orgname'_update_in_envelope.pb -c '$channelname' -o orderer.'$nameofnetwork'.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem 
    set +x
    echo
    echo "========= Config transaction to add '$orgname' to network submitted! =========== "
    echo'> ./scripts/addingOrgToChannelPart1.sh
    chmod +x ./scripts/addingOrgToChannelPart1.sh
    
    cliname=$(python operations.py getCliName $org1inchannel)
    docker exec $cliname scripts/addingOrgToChannelPart1.sh
    
    sleep 5
    echo -e '#!/bin/bash

    # import utils
    . scripts/utils.sh

    # setting peer0 of '$orgname' environment variables
    setGlobals 0 '$orgname'

    echo "Fetching channel config block from orderer..."
    set -x
    peer channel fetch 0 '$channelname'.block -o orderer.'$nameofnetwork'.com:7050 -c '$channelname' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem 
    set +x'> ./scripts/addingOrgToChannelPart2.sh
    chmod +x ./scripts/addingOrgToChannelPart2.sh
    
     ############################## Running the script in container  #############################################
    cliname=$(python operations.py getCliName $orgname)
    docker exec $cliname scripts/addingOrgToChannelPart2.sh
    sleep 2
    echo "############################################################################################################
        ##################################   $orgname is added to CHANNEL $channelname  ############################
        ############################################################################################################"
    

    ############################## adding org to channel in channelinfo.json file  #############################################
    python operations.py addOrgToChannel $channelname $orgname

    ############################## updating org count in channel in channelinfo.json file  #############################################
    python operations.py updateChannelOrgCount $channelname 
    
    ############################## This Scripts is used to add org in channel consortium in configtx.yaml  #############################################
    echo -n '#!/bin/bash
sed -i "s/#'$channelname'configtx/\n                    - *'$orgname'\n#'$channelname'configtx/" configtx.yaml'> tempscript.sh

    chmod +x tempscript.sh
    ./tempscript.sh
    rm tempscript.sh
    
    
else   
    echo -e '#!/bin/bash
    
    echo "Installing jq"
    apt-get -y update && apt-get -y install jq
    
    # import utils
    . scripts/utils.sh

    # setting orderer environment variables
    setOrdererGlobals
    
    # Fetch the config for the channel, writing it to config.json
    echo "Fetching the most recent configuration block for the channel"
    set -x
    peer channel fetch config config_block.pb  -o orderer.'$nameofnetwork'.com:7050 -c '$channelname' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem
    set +x
    
    echo "Decoding config block to JSON and isolating config to  "config.json""
    set -x
    configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > "config.json"
    set +x
    
    # Modify the configuration to append the new org
    set -x
    jq -s '\''.[0] * {"channel_group":{"groups":{"Application":{"groups": {"'$orgname'MSP":.[1]}}}}}'\'' config.json ./channel-artifacts/'$orgname'.json > modified_config.json
    set +x

    # Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to org3_update_in_envelope.pb
    set -x
    configtxlator proto_encode --input config.json --type common.Config > original_config.pb

    configtxlator proto_encode --input modified_config.json --type common.Config > modified_config.pb

    configtxlator compute_update --channel_id '$channelname' --original original_config.pb --updated modified_config.pb > config_update.pb

    configtxlator proto_decode --input config_update.pb  --type common.ConfigUpdate > config_update.json

    echo '\''{"payload":{"header":{"channel_header":{"channel_id":"'$channelname'", "type":2}},"data":{"config_update":'\''$(cat config_update.json)'\''}}}'\'' | jq . > config_update_in_envelope.json

    configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope > '$orgname'_update_in_envelope.pb
    set +x

    echo
    echo "========= Config transaction to add '$orgname' to network created ===== "
    echo
    
    # import utils
    . scripts/utils.sh' > ./scripts/addingOrgToChannelPart1.sh
    
    #Signing config transaction from all orgs in channel
    count=$(($nooforgsinchannel-1))
    for (( i=0; i<$count; i++));
     do
        orgsinchannel=$(python operations.py getOrgFromChannel $channelname $i )
        # setting peer0  environment variables
        echo -e 'setGlobals 0 '$orgsinchannel'
        echo "Signing config transaction by '$orgname'"
        echo
        set -x
        peer channel signconfigtx -f '$orgname'_update_in_envelope.pb
        set +x' >> ./scripts/addingOrgToChannelPart1.sh
     done

     orgsinchannel=$(python operations.py getOrgFromChannel $channelname $count )
    echo -e '
        # setting peer0 of '$orgname' environment variables
        setGlobals 0 '$orgsinchannel'
        echo "Signing config transaction"
        echo
        set -x
        peer channel signconfigtx -f '$orgname'_update_in_envelope.pb
        set +x

        echo
        echo "========= Submitting transaction from a different peer (peer0.'$orgname') which also signs it ========= "
        echo
        set -x
        peer channel update -f '$orgname'_update_in_envelope.pb -c '$channelname' -o orderer.'$nameofnetwork'.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem
        set +x' >> ./scripts/addingOrgToChannelPart1.sh 
     echo -e 'set -x' >> ./scripts/addingOrgToChannelPart1.sh
    chmod +x ./scripts/addingOrgToChannelPart1.sh

    org1inchannel=$(python operations.py getOrgFromChannel $channelname 0 )
    cliname=$(python operations.py getCliName $org1inchannel)
    docker exec $cliname scripts/addingOrgToChannelPart1.sh

    sleep 2
    echo -e '#!/bin/bash
        
    # import utils
    . scripts/utils.sh
    
    # setting peer0 of '$orgname' environment variables
    setGlobals 0 '$orgname'
    
    echo "Fetching channel config block from orderer..."
    set -x
    peer channel fetch 0 '$channelname'.block -o orderer.'$nameofnetwork'.com:7050 -c '$channelname' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/'$nameofnetwork'.com/orderers/orderer.'$nameofnetwork'.com/msp/tlscacerts/tlsca.'$nameofnetwork'.com-cert.pem
    set +x '> ./scripts/addingOrgToChannelPart2.sh
    chmod +x ./scripts/addingOrgToChannelPart2.sh
    
    ############################## Running the script in container  #############################################
    cliname=$(python operations.py getCliName $orgname)
    docker exec $cliname scripts/addingOrgToChannelPart2.sh

    echo "############################################################################################################
        ##################################    $orgname is added to CHANNEL $channelname    #########################
        ############################################################################################################"

    ############################## adding org to channel in channelinfo.json file  #############################################
    python operations.py addOrgToChannel $channelname $orgname
    
    ############################## adding org to channeljoin in channelinfo.json file  #############################################
    python operations.py addOrgToChannelJoin $channelname $orgname

    ############################## updating org count in channel in channelinfo.json file  #############################################
    python operations.py updateChannelOrgCount $channelname 
    
    ############################## This Scripts is used to add org in channel consortium in configtx.yaml  #############################################
    echo -n '#!/bin/bash
sed -i "s/#'$channelname'configtx/                    - *'$orgname'\n#'$channelname'configtx/" configtx.yaml'> tempscript.sh

    chmod +x tempscript.sh
    ./tempscript.sh
    rm tempscript.sh
fi