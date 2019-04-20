#!/bin/bash 

########################## updateing no of peer in crypto-config.yaml #########################################

peerno=$1
orgname=$2
channelname=$3

cliname=$(python operations.py getCliName $orgname)

docker exec $cliname scripts/joinchannelscript.sh $peerno $orgname $channelname

python operations.py addPeerJoinChannel $channelname $orgname $peerno


