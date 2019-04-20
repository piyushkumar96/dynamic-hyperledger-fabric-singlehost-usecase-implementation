#!/bin/bash

echo "Enter the NetworkName No._of_Orgs Org_Name No_Of_Peers :"
read -a input1
netname=${input1[0]}
input1=${input1[@]}

./first.sh $input1

echo "Enter the ChannelName1 OrgName1 OrgName2 .. % (dellimator) ChannelName2 OrgName ..."
read  input2

./configtx-file-gen.sh $input2 

./cryptogeneration.sh

./channelartifactsgen.sh

./replaceprivatekeys.sh


echo "############################################################################################################
      ###############################    NETWORK CREATION IN PROGRESS     ########################################
      ############################################################################################################"
docker-compose -f docker-compose-e2e.yaml --project-name $netname up -d 2>&1


echo "############################################################################################################
      ##################################    NETWORK IS UP            #############################################
      ############################################################################################################"

sleep 10

temp1=$netname"cli"

docker exec $temp1 scripts/startchannelcreation.sh 

echo "############################################################################################################
      ##################################    CHANNELS ARE CREATED            ######################################
      ############################################################################################################"

./orgjson.sh
 rm ./orgjson.sh


python operations.py updateNetworkStatus networkstatus



 


   

