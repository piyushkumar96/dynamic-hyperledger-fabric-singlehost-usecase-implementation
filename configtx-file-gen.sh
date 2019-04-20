#!/bin/bash
array=( "$@" )
arraylength=${#array[@]}

echo -e '#!/bin/bash

. ./scripts/utils.sh
'> ./scripts/startchannelcreation.sh

##echo -n ' { "channel" : [ '> ./network-configuration/channelinfo.json

str=' { '
str1=$str'"channel" : [ '                    #for storing the Orgs in channel
str2='"channeljoin" : [ '                    #for storing the peers in channel


t=0
k=0
l=0
orgcount=0
chcount=0
for (( i=1; i<${arraylength}+1; i++ ));
do
  if [ $t -eq 0 ]; then
       echo -n 'createChannel 0 ' >> ./scripts/startchannelcreation.sh
  fi
  if [ ${array[$i-1]} == "%" ]; then
      t=0
      k=0
      echo ' '$tempvarr >> ./scripts/startchannelcreation.sh
      echo $'\n' >> ./scripts/startchannelcreation.sh
      orgcount=$(($orgcount -1))
      str1=$str1'], "orgcount" : "'$orgcount'" },'
      str2=$str2']},'
      ##echo -n '], "orgcount" : "'$orgcount'" },'>> ./network-configuration/channelinfo.json
      orgcount=0
      echo -e '#'$tempvarr'configtx'>> configtx.yaml
      continue
  else
    orgcount=$(($orgcount +1))
    fi
  if [ $t -eq 0 ]; then 
    echo -e '    '${array[$i-1]}'Channel:
        Consortium: SampleConsortium
        Application:
            <<: *ApplicationDefaults
            Organizations:' >> configtx.yaml
    tempvarr=${array[$i-1]}
    
    #echo -n ' { "channelname" : "'${array[$i-1]}'", "org" : ['>> ./network-configuration/channelinfo.json
    str1=$str1' { "channelname" : "'${array[$i-1]}'", "org" : ['
    str2=$str2' { "channelname" : "'${array[$i-1]}'", "joined" : ['
    
    chcount=$(($chcount +1))
    t=1
    l=0
  else  
    echo -e '                    - *'${array[$i-1]} >> configtx.yaml
    if [ $l -ne 0 ]; then
       ##echo -n ','>> ./network-configuration/channelinfo.json
       str1=$str1','
       str2=$str2','
    else
       l=1
    fi
    ##echo -n '"'${array[$i-1]}'"' >> ./network-configuration/channelinfo.json
    str1=$str1'"'${array[$i-1]}'"'
    str2=$str2'{"orgname" : "'${array[$i-1]}'", "peer" : []}'  

    if [ $k -eq 0 ]; then
       echo -n ' '${array[$i-1]} >> ./scripts/startchannelcreation.sh
       k=1
    fi   
  fi
done

orgcount=$(($orgcount -1))

str1=$str1'] , "orgcount" : "'$orgcount'" }] , '$str2' ] }] ,  "channelcount" : "'$chcount'"}' 

echo -e $str1 > ./network-configuration/channelinfo.json 

##echo -n '], "orgcount" : "'$orgcount'" }], "channelcount" : "'$chcount'" }'>> ./network-configuration/channelinfo.json

#####################################  for future addition of new channel in profile   ########################################################
echo -e '#newchannelconfigtx' >> configtx.yaml

echo ' '$tempvarr >> ./scripts/startchannelcreation.sh
chmod +x ./scripts/startchannelcreation.sh

t=0
for (( i=1; i<${arraylength}+1; i++ ));
do
  if [ ${array[$i-1]} == "%" ]; then
      t=0
      continue
  fi
  if [ $t -eq 0 ]; then 
    echo -e '  echo "#################################################################"
    echo "### Generating channel configuration transaction '${array[$i-1]}'.tx ###"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile '${array[$i-1]}'Channel -outputCreateChannelTx ./channel-artifacts/'${array[$i-1]}'channel.tx -channelID '${array[$i-1]}'
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate channel configuration transaction..."
      exit 1
    fi

    echo' >> channelartifactsgen.sh
    tempchannel=${array[$i-1]}
    t=1
  else 
    echo -e '  echo "#################################################################"
    echo "#######    Generating anchor peer update for '${array[$i-1]}'MSP   ##########"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile '$tempchannel'Channel -outputAnchorPeersUpdate ./channel-artifacts/'${array[$i-1]}'MSPanchors'$tempchannel'.tx -channelID '$tempchannel' -asOrg '${array[$i-1]}'MSP
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate anchor peer update for '${array[$i-1]}'MSP..."
      exit 1
    fi' >> channelartifactsgen.sh
    fi
done 
