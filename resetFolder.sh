#!/bin/bash
shopt -s extglob
sudo rm -rf !("addOrgToChannel.sh"|"bcnetsetup.sh"|"configtx-file-gen.sh"|"createChannel.sh"|"createNewChannel.sh"|"firstnetwork.sh"|"firstnetworkup.sh"|"newOrgAddtion.sh"|"operations.py"|"README.md"|"resetFolder.sh")


mkdir base channel-artifacts newChannelFiles scripts tempFolder network-configuration
echo "8000" >./network-configuration/portca.txt
echo "7100" >./network-configuration/portpeer.txt

docker rm -f $(docker ps -aq)
docker network prune