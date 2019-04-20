#!/bin/bash

echo "###################################################################"
       echo "### Generating channel configuration transaction challchannel.tx ###"
       echo "###################################################################"
  set -x
  ../bin/configtxgen -profile challChannel -outputCreateChannelTx ./channel-artifacts/challchannel.tx -channelID chall
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi
 echo
  echo "#########################################################################################"
  echo "### Generating anchor peer update for sbiMSP for Channel chall #####"
  echo "#########################################################################################"
  set -x
  ../bin/configtxgen -profile challChannel -outputAnchorPeersUpdate ./channel-artifacts/sbiMSPanchorschall.tx -channelID chall -asOrg sbiMSP
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for sbiMSP..."
    exit 1
  fi
  echo
