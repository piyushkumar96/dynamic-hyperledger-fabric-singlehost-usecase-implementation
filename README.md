# dynamic-hyperledger-fabric-singlehost
This repository contains scripts to spawn the dynamic hyperledger fabric network on single host (dockers)

Note:- I also wrote scripts which spawn dynamic hyperledger fabric natwork on multi host (kubernetes cluster). To get help regarding this please contact me on mail: piyush25032@gmail.com

#Descriptions of Files

########################  file for creating all files required for firstTime Blockchain network ########################

File1:- firstnetwork.sh

function:- This file creates the first time network of blockchain and simultaneously generate various important files and folders required for blockchain network creation few of them defined below:-
i)      crypto-config.yaml 
ii)     configtx.yaml
iii)     joinchannel.sh file
iv)      addnewpeer.sh file
v)     newOrgAddtion.sh file

command:- ./firstnetwork.sh arg1 arg2 arg3 arg4 arg5 arg6 ......
arg1:- blockchain network name,
arg2:- number of organisation in BC network initially,
arg3:- first org name
arg4:- number of peers in first org
arg5:- second org name
arg6:- number of peers in second org
and so on.

example:- ./firstnetwork.sh bcnet 2 org1 1 org2 2
          ./firstnetwork.sh network1 3 org1 1 org2 2 org3 3

########################  file for channel creation in firstTime network ########################

File2:- configtx-file-gen.sh 

function:- This file creates configtx.yaml and other channel confriguration files required for first time blockchain network.

command:- ./configtx-file-gen.sh arg1 arg2 arg3 .... % arg4 arg5 ......
arg1:- channel name,
arg2:- first organisation name,
arg3:- second orginsation name
so on ....

%  separator used for ending one channel confriguration

arg4:- another channel name
arg5:- first organisation name
arg6:- second orginsation name
and so on.

example:- ./configtx-file-gen.sh ch1 org1 % ch2 org2
          ./configtx-file-gen.sh ch1 org1 % ch2 org2 % ch12 org1 org2


########################  files for channel confriguration ##############################

File3:- joinchannel.sh 

function:- This file helps peers to join channel 

command:- ./firstnetwork.sh arg1 arg2 arg3
arg1:- peer number (0,1,2 ....)
arg2:- org name
arg3:- channel_name

example:- ./joinchannel.sh 0 org1 ch1
          ./joinchannel.sh 1 org2 ch12

-----------------------------------------------------------------------------------------

File4:- ./createChannel.sh 

function:- This file helps to create new channel 

command:- ./createChannel.sh arg1
arg1:- channel name

example:- ./createChannel.sh newchannel
          ./createChannel.sh channel

------------------------------------------------------------------------------------------

File5:- ./createNewChannel.sh 

function:- This file helps to create new channel with multiple orgs in a row.

command:- ./createNewChannel.sh arg1 arg2 arg3 arg4 .....

arg1:- channel name
arg2:- org name
arg3:- org name
arg4:- org name

example:- ./createNewChannel.sh newchannel org1 org2 org3 org4
          ./createNewChannel.sh channel12 org1 org2 

---------------------------------------------------------------------------------------------

File6:- ./addOrgToChannel.sh 

function:- This file helps to add org (which is not in channel) to existing channel 

command:- ./addOrgToChannel.sh arg1 arg2

arg1:- existing channel name
arg2:- org name to be added 

example:- ./addOrgToChannel.sh newchannel org5
          ./addOrgToChannel.sh channel12 org3 



######################## files for adding new peer and orgs in existing BC network ########################

File7:- ./addnewpeer.sh 

function:- This file helps to add new peer to existing org 

command:- ./addnewpeer.sh org1

arg1:- existing org name in which new peer to be added

example:- ./addnewpeer.sh org1
          ./addnewpeer.sh org3

-------------------------------------------------------------------------------------------

File8:- ./newOrgAddtion.sh 

function:- This file helps to add new organisation to existing BC network 

command:- ./newOrgAddtion.sh arg1 arg2

arg1:- new org name which to be added

example:- ./newOrgAddtion.sh orgnew 5
          ./newOrgAddtion.sh org10 10

########################  JSON files storing the blockchain network confriguration  ########################

orgstructure.json :- this file stores nameofnetwork, no. of org., org with there no. of peers.
orgsports.json    :- this file stores ports of peers of all orgs and their CAs 
channelinfo.json  :- this file stores the channel info like number of channel, orgs in channel,                     peers which joined the channel etc.
cliname.json      :- this files stores cli container name for an org.

######################## file contains various funtion which help to get and store network confriguration details in JSON files ########################

operations.py

######################## files (network-configuration) are used for ports for peer and cas ########################

portpeer.txt :- port for peers
portca.txt :- port for cas
