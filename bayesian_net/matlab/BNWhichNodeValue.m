function idx = BNWhichNodeValue(netobj, node, valuename)

idx = find(strcmp(netobj.nodeValueNames{node}, valuename));
