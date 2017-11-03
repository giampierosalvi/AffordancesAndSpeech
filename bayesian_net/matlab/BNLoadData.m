function netobj = BNLoadData(netobj, datafilename)
% BNLoadData: loads data into BN object
%
% Inputs:
% netobj: object returned by createBN
% datafilename: filename to the data file
% NOTE: should write more on format
%
% See also createBN, BNSetDefaults
%
% (C) 2009-2017, Giampiero Salvi, giampi@kth.se


% assumption: values in data file in the same order as in the nodes (but we
% check this)

fid = fopen(datafilename);
% parse header
line=fgetl(fid);
lcont = regexp(line, '[^\s]*', 'match');
% check consistency
if(length(lcont) ~= netobj.N)
    error('wrong number of columns in data file');
end
equalnodes = strcmpi(lcont, netobj.nodeNames);
if(~all(equalnodes))
    different = find(~equalnodes);
    disp('Data:');
    disp(lcont(different));
    disp('Network:')
    disp(netobj.nodeNames(different));
    error('missmatch columns/network nodes');
end
% load data (converting strings into indexes)
netobj.data = [];
while(1)
    line=fgetl(fid);
    if ~ischar(line), break, end
    lcont = regexp(line, '[^\s]*', 'match');
    ldata = zeros(1, length(lcont));
    for h=1:length(lcont)
        idx = find(strcmpi(lcont(h), netobj.nodeValueNames{h}));
        if isempty(idx)
            error('element not recognized: %s\n', lcont{h});
        end
        ldata(h) = idx;
    end
    netobj.data = [netobj.data ldata'];
end
% transposing for the BNT functions
%netobj.data = netobj.data';
fclose(fid);
