#!/bin/bash

channelname=$1
nameofnetwork=$(python operations.py getNetworkName)

# ############################## This Orgs helps to Create New Channel And Help other Org to Join Channel #############################################
# firstorg="common"

######################## This Orgs helps to Create New Channel And Help other Org to Join Channel ########################
firstorg=$(python operations.py getNetworkDetail firstorg)

############################## Update No. Of Channel Count In channelinfo.json file #############################################
python operations.py updateChannelCount

############################## Adding Channel Details In channelinfo.json file #############################################
python operations.py addChannelDetail channel '{ "channelname" : "'$channelname'", "org" : ["'$firstorg'"], "orgcount" : "1" }'

######################## Adding ChannelJoin Details In channelinfo.json file ########################
python operations.py addChannelDetail channeljoin '{ "channelname" : "'$channelname'", "joined" : [] }'



############################## This Scripts is used to add Newchannel to network  #############################################
echo -e '#!/bin/bash

. ./scripts/utils.sh

createChannel 0 '$firstorg' '$channelname' ' > ./scripts/startchannelcreation.sh
chmod +x ./scripts/startchannelcreation.sh

############################## This Scripts is used to add Newchannel details in configtx.yaml  #############################################
echo -n '#!/bin/bash
sed -i "s/#newchannelconfigtx/    '$channelname'Channel:\n        Consortium: SampleConsortium\n        Application:\n            <<: *ApplicationDefaults\n            Organizations:\n                    - *'$firstorg'\n#'$channelname'configtx\n#newchannelconfigtx/" configtx.yaml'> tempscript.sh

chmod +x tempscript.sh
./tempscript.sh
rm tempscript.sh



############################# This script is used to create artifacts for new channel   #####################################

echo  '#!/bin/bash

echo "###################################################################"
       echo "### Generating channel configuration transaction '$channelname'channel.tx ###"
       echo "###################################################################"
  set -x
  ../bin/configtxgen -profile '$channelname'Channel -outputCreateChannelTx ./channel-artifacts/'$channelname'channel.tx -channelID '$channelname'
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi' > $channelname-channel-artifacts-generate.sh

 echo -e ' echo
  echo "#########################################################################################"
  echo "### Generating anchor peer update for '$firstorg'MSP for Channel '$channelname' #####"
  echo "#########################################################################################"
  set -x
  ../bin/configtxgen -profile '$channelname'Channel -outputAnchorPeersUpdate ./channel-artifacts/'$firstorg'MSPanchors'$channelname'.tx -channelID '$channelname' -asOrg '$firstorg'MSP
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for '$firstorg'MSP..."
    exit 1
  fi
  echo'>>  $channelname-channel-artifacts-generate.sh

chmod +x $channelname-channel-artifacts-generate.sh
./$channelname-channel-artifacts-generate.sh

############################# Moving the channel-artifacts-generate.sh file to newChannelFiles location  #####################################
mv $channelname-channel-artifacts-generate.sh ./newChannelFiles/

############################# Running The scripts to create channel inside container  #####################################
cliname=$(python operations.py getCliName $firstorg)
docker exec $cliname scripts/startchannelcreation.sh 

echo "############################################################################################################
      ##################################    CHANNEL $channelname IS CREATED            ######################################
      ############################################################################################################"

