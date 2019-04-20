#!/bin/bash

array=( "$@" )
arraylength=${#array[@]}
nameofnetwork=$(python operations.py getNetworkName)

echo -e '#!/bin/bash

. ./scripts/utils.sh
'> ./scripts/startchannelcreation.sh

echo -n 'createChannel 0 '${array[1]}' '${array[0]}' ' >> ./scripts/startchannelcreation.sh
echo -n '#!/bin/bash
sed -i "s/#newchannelconfigtx/    '${array[0]}'Channel:\n        Consortium: SampleConsortium\n        Application:\n            <<: *ApplicationDefaults\n            Organizations:'> tempscript.sh

            
for (( i=2; i<${arraylength}+1; i++ ));
do
    echo -n '\n                    - *'${array[$i-1]} >> tempscript.sh
done  

echo -n '\n#newchannelconfigtx/" configtx.yaml' >> tempscript.sh

chmod +x tempscript.sh
./tempscript.sh
rm tempscript.sh

chmod +x ./scripts/startchannelcreation.sh

######################################################################################

echo  '#!/bin/bash

echo "###################################################################"
       echo "### Generating channel configuration transaction '${array[0]}'channel.tx ###"
       echo "###################################################################"
  set -x
  ../bin/configtxgen -profile '${array[0]}'Channel -outputCreateChannelTx ./channel-artifacts/'${array[0]}'channel.tx -channelID '${array[0]}'
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi' > ${array[0]}channel-artifacts-generate.sh

for (( i=2; i<${arraylength}+1; i++ ));
do
 echo -e ' echo
  echo "#########################################################################################"
  echo "### Generating anchor peer update for '${array[$i-1]}'MSP for Channel '${array[0]}' #####"
  echo "#########################################################################################"
  set -x
  ../bin/configtxgen -profile '${array[0]}'Channel -outputAnchorPeersUpdate ./channel-artifacts/'${array[$i-1]}'MSPanchors'${array[0]}'.tx -channelID '${array[0]}' -asOrg '${array[$i-1]}'MSP
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for '${array[$i-1]}'MSP..."
    exit 1
  fi
  echo'>> ${array[0]}channel-artifacts-generate.sh
done



chmod +x ${array[0]}channel-artifacts-generate.sh

./${array[0]}channel-artifacts-generate.sh

mv ${array[0]}channel-artifacts-generate.sh ./newChannelFiles/

cliname=$(python operations.py getCliName ${array[1]})

docker exec $cliname scripts/startchannelcreation.sh 

echo "############################################################################################################
      ##################################    CHANNEL ${array[0]} IS CREATED            ######################################
      ############################################################################################################"

