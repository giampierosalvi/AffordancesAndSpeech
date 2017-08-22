function node = BNWhichNode(netobj, nodename)

node = find(strcmp(netobj.nodeNames, nodename));
