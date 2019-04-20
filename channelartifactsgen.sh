#!/bin/bash
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi

  echo "##########################################################"
  echo "#########  Generating Orderer Genesis block ##############"
  echo "##########################################################"
  # Note: For some unknown reason (at least for now) the block file cant be
  # named orderer.genesis.block or the orderer will fail to launch!
  set -x
  ../bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate orderer genesis block..."
    exit 1
  fi
  echo
  echo "#################################################################"
    echo "### Generating channel configuration transaction chsbihdfc.tx ###"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile chsbihdfcChannel -outputCreateChannelTx ./channel-artifacts/chsbihdfcchannel.tx -channelID chsbihdfc
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate channel configuration transaction..."
      exit 1
    fi

    echo
  echo "#################################################################"
    echo "#######    Generating anchor peer update for sbiMSP   ##########"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile chsbihdfcChannel -outputAnchorPeersUpdate ./channel-artifacts/sbiMSPanchorschsbihdfc.tx -channelID chsbihdfc -asOrg sbiMSP
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate anchor peer update for sbiMSP..."
      exit 1
    fi
  echo "#################################################################"
    echo "#######    Generating anchor peer update for hdfcMSP   ##########"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile chsbihdfcChannel -outputAnchorPeersUpdate ./channel-artifacts/hdfcMSPanchorschsbihdfc.tx -channelID chsbihdfc -asOrg hdfcMSP
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate anchor peer update for hdfcMSP..."
      exit 1
    fi
  echo "#################################################################"
    echo "### Generating channel configuration transaction chhdfcicici.tx ###"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile chhdfciciciChannel -outputCreateChannelTx ./channel-artifacts/chhdfcicicichannel.tx -channelID chhdfcicici
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate channel configuration transaction..."
      exit 1
    fi

    echo
  echo "#################################################################"
    echo "#######    Generating anchor peer update for hdfcMSP   ##########"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile chhdfciciciChannel -outputAnchorPeersUpdate ./channel-artifacts/hdfcMSPanchorschhdfcicici.tx -channelID chhdfcicici -asOrg hdfcMSP
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate anchor peer update for hdfcMSP..."
      exit 1
    fi
  echo "#################################################################"
    echo "#######    Generating anchor peer update for iciciMSP   ##########"
    echo "#################################################################"
    set -x
    ../bin/configtxgen -profile chhdfciciciChannel -outputAnchorPeersUpdate ./channel-artifacts/iciciMSPanchorschhdfcicici.tx -channelID chhdfcicici -asOrg iciciMSP
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate anchor peer update for iciciMSP..."
      exit 1
    fi
