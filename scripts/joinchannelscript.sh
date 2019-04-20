#!/bin/bash 

peer=$1
orgname=$2
channelname=$3
. ./scripts/utils.sh 

joinChannelWithRetry $peer $orgname $channelname


