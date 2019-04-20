#!/bin/bash
# Copy the template to the file that will be modified to add the private key
  cp docker-compose-e2e-template.yaml docker-compose-e2e.yaml

  # The next steps will replace the templates contents with the
  # actual values of the private key file names for the two CAs.
  CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/sbi.bankconsortiumbcnet.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed -i "s/CA0_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/hdfc.bankconsortiumbcnet.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed -i "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
cd crypto-config/peerOrganizations/icici.bankconsortiumbcnet.com/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed -i "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-e2e.yaml
