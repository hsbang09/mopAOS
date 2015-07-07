function [EI,IGD,HV] = getAllResults(path,selector,creditDef,problemName,numObj)
%Given a path, the heuristic selector name, credit definition name, and
%problem name this function will get all the results from the given path 
%with files that include the selector name and the credit definition name. 
%
%This function returns the epsilon indicator EI, generational distance GD,
%and hyper volume HV as a n x m matrix where n is the number files
%containing the selector name and credit definition name and m is the
%number of values collected per file.

origin = cd(path);
files = dir('*.NDPop');
nfiles = length(files);
EI  = zeros(nfiles,1);
IGD  = zeros(nfiles,1);
HV  = zeros(nfiles,1);
yesFile = false(nfiles,1);
for i=1:nfiles
    a = strfind(files(i).name,selector);
    b = strfind(files(i).name,creditDef);
    c = strfind(files(i).name,problemName);
    if ~isempty(a) && ~isempty(b) && ~isempty(c)
        approxSet = readObjectives(files(i).name,numObj);
        HV(i,1) = computeHV(approxSet,[2,2],'min');
        
        cd(origin)
        cd('pf')
        reffile = dir([problemName '*']);
        refSet = readObjectives(reffile(1).name,numObj);
        
        IGD(i,1) = computeIGD(approxSet,refSet);
%         [EI(i,:),GD(i,:),HV(i,:)] = getMOEAIndicators(strcat(path,filesep,files(i).name));
        yesFile(i) = true;
        
        cd(path)
    end
end

cd(origin)

EI = EI(yesFile,:);
IGD = IGD(yesFile,:);
HV = HV(yesFile,:);

end