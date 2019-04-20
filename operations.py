import yaml
import json
from sys import argv

def changeYamlCount(arg1):
    with open('crypto-config.yaml') as f:
            doc = yaml.load(f)
    i = -1
    for ele in doc['PeerOrgs']:
        i += 1
        if ele['Name'] == arg1:
            print(ele['Template']['Count'], i)
            with open('crypto-config.yaml', 'w') as fr:
                doc['PeerOrgs'][i]['Template']['Count'] += 1
                fr.write(yaml.safe_dump(doc))

def addPeerPort(arg1,arg2,arg3):
    with open('./network-configuration/orgsports.json') as f:
        data = json.load(f)
        i = -1
        for ele in data['org']:
            i += 1
            if ele['orgId'] == arg1:
                data["org"][i]["peer"].append( {"peerName": arg2,"port": arg3})
                print(data)
                with open('./network-configuration/orgsports.json', 'w') as fr:
                    json.dump(data, fr)

def addPortDetail(arg1,arg2):
    print(arg1+"$$$$$$$"+arg2)
    with open('./network-configuration/orgsports.json') as f:
        data = json.load(f)
        data[arg1].append(json.loads(arg2))
        #print(data)
        with open('./network-configuration/orgsports.json', 'w') as fr:
            json.dump(data, fr)

def addDetail(arg1,arg2):
    with open(arg1) as f:
        data = json.load(f)
        input = json.loads(arg2)
        key = input.keys() #returns array of keys
        value = input[key[0]]
        data[key[0]] = value
        print(data)
        with open(arg1, 'w') as fr:
            json.dump(data, fr)

def getPeerPort(arg1,arg2):
    with open('./network-configuration/orgsports.json') as f:
        data = json.load(f)
        for ele in data['org']:
            if ele['orgId'] == arg1:
                arr = ele['peer']
                for k in arr:
                    if k['peerName'] == arg2:
                        port = k['port']
                        print (port)
                        return port
def getCaPort(arg1):
    with open('./network-configuration/orgsports.json') as f:
        data = json.load(f)
        for ele in data['caports']:
            if ele['orgId'] == arg1:
                port = ele['port']
                print (port)
                return port
def getOrgCount(arg1):
    with open('./network-configuration/orgstructure.json') as f:
        data1 = json.load(f)
        count = int(data1[arg1])
        print (count)
        return count

def updateOrgCount(arg1):
    with open('./network-configuration/orgstructure.json') as f:
        data1 = json.load(f)
        count = int(data1[arg1]) + 1
        data1[arg1] = str(count)
        with open('./network-configuration/orgstructure.json', 'w') as fw:
            json.dump(data1, fw)

def updateNetworkStatus(arg1):
    with open('./network-configuration/orgstructure.json') as f:
        data1 = json.load(f)
        data1[arg1] = "up"
        with open('./network-configuration/orgstructure.json', 'w') as fw:
            json.dump(data1, fw)

def getNetworkName():
    with open('./network-configuration/orgstructure.json') as f:
        data = json.load(f)
        name = data['nameofnetwork']
        print (name)
        return name

def getNetworkDetail(arg1):
    with open('./network-configuration/orgstructure.json') as f:
        data = json.load(f)
        name = data[arg1]
        print (name)
        return name

def getCliName(arg1):
    with open('./network-configuration/cliname.json') as f:
        data = json.load(f)
        name = data[arg1]
        print (name)
        return name

def addOrgToChannel(arg1,arg2):
    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        i = -1
        for ele in data['channel']:
            i += 1
            if ele['channelname'] == arg1:
                data["channel"][i]["org"].append( arg2)
                print(data)
                with open('./network-configuration/channelinfo.json', 'w') as fr:
                    json.dump(data, fr)
def getOrgFromChannel(arg1,arg2):
    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        i = -1
        for ele in data['channel']:
            i += 1
            if ele['channelname'] == arg1:
                info=data["channel"][i]["org"][int(arg2)]
                print(info)
                return info

def getChannelOrgCount(arg1):
    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        i = -1
        for ele in data['channel']:
            i += 1
            if ele['channelname'] == arg1:
                info=data["channel"][i]["orgcount"]
                print(info)
                return info

def updateChannelOrgCount(arg1):
    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        i = -1
        for ele in data['channel']:
            i += 1
            if ele['channelname'] == arg1:
                data["channel"][i]["orgcount"]=int(data["channel"][i]["orgcount"])+1
                with open('./network-configuration/channelinfo.json', 'w') as fw:
                    json.dump(data, fw)

def addChannelDetail(arg1,arg2):

    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        data[arg1].append(json.loads(arg2))
        #print(data)
        with open('./network-configuration/channelinfo.json', 'w') as fr:
            json.dump(data, fr)

def updateChannelCount():
    with open('./network-configuration/channelinfo.json') as f:
        data1 = json.load(f)
        count = int(data1["channelcount"]) + 1
        data1["channelcount"] = str(count)
        with open('./network-configuration/channelinfo.json', 'w') as fw:
            json.dump(data1, fw)

def getChannelCount():
    with open('./network-configuration/channelinfo.json') as f:
        data1 = json.load(f)
        count =data1["channelcount"]
        print(count)
        return count

def addPeerJoinChannel(arg1,arg2,arg3):
    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        i = -1
        j = -1
        for ele in data['channeljoin']:
            i +=1
            if ele['channelname'] == arg1:
                for ele2 in ele['joined']:
                    j += 1
                    if ele2['orgname'] == arg2:
                       data["channeljoin"][i]["joined"][j]["peer"].append(arg3)
                with open('./network-configuration/channelinfo.json', 'w') as fr:
                    json.dump(data, fr)

def statusJoinChannel(arg1,arg2,arg3):
    with open('./network-configuration/channelinfo.json') as f:
        data = json.load(f)
        for ele in data['channeljoin']:
            if ele['channelname'] == arg1:
                for ele2 in ele['joined']:
                    if ele2['orgname'] == arg2:
                        for ele3 in ele2['peer']:
                             if ele3 == arg3:
                                  print("1")
                                  return 1
        print("0")
        return 0


def main(fn):
    if fn == "changeYamlCount":
       changeYamlCount(argv[2])
    elif fn == "addPeerPort":
        addPeerPort(argv[2],argv[3],argv[4])
    elif fn == "addPortDetail":
        addPortDetail(argv[2],argv[3])
    elif fn == "getPeerPort":
        getPeerPort(argv[2],argv[3])
    elif fn == "getCaPort":
        getCaPort(argv[2])
    elif fn == "getOrgCount":
        getOrgCount(argv[2])
    elif fn == "updateOrgCount":
        updateOrgCount(argv[2])
    elif fn == "getNetworkName":
        getNetworkName()
    elif fn == "getNetworkDetail":
        getNetworkDetail(argv[2])  
    elif fn == "getCliName":
        getCliName(argv[2])
    elif fn == "addCliDetail":
        addCliDetail(argv[2])
    elif fn == "addDetail":
        addDetail(argv[2],argv[3])
    elif fn == "addOrgToChannel":
        addOrgToChannel(argv[2],argv[3])
    elif fn == "getOrgFromChannel":
        getOrgFromChannel(argv[2],argv[3])
    elif fn == "getChannelOrgCount":
        getChannelOrgCount(argv[2])
    elif fn == "updateChannelOrgCount":
        updateChannelOrgCount(argv[2])
    elif fn == "addChannelDetail":
        addChannelDetail(argv[2],argv[3])
    elif fn == "updateChannelCount":
        updateChannelCount()
    elif fn == "getChannelCount":
        getChannelCount()
    elif fn == "updateNetworkStatus":
        updateNetworkStatus(argv[2])
    elif fn == "addPeerJoinChannel":
        addPeerJoinChannel(argv[2],argv[3],argv[4])
    elif fn == "statusJoinChannel":
        statusJoinChannel(argv[2],argv[3],argv[4])
    else:
        print("No function exist for this key")

main(argv[1])


