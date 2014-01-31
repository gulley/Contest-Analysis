function [dOut, allLineList, firstTimeIndexList, lastTimeIndexList] = hashFiles(dIn,cleanFlag)
%hashFiles
%   [dOut, allLineList, firstTimeIndexList] = hashFiles(dIn)
% TESTED: Looks like it works well.
if nargin < 2
    cleanFlag = true;
end

d = dIn;

allLineList_non_unique = {};
nLines = 0;

% Get the code
db = connectToContestDatabase;
for i = 1:length(d)
    codeRaw = getSubmissionCode(d(i).id, db);
    
    if cleanFlag
        
        try
            % Re-emit cleaned code
            tr = mtree(codeRaw);
            code = tree2str(tr);
            
            % Strip the code down to a list of functions only
            %             code = fcn_list(codeRaw);
            d(i).failedToParse = false;
        catch
            fprintf('Parse error. Skipping entry %d\n',d(i).id)
            d(i).failedToParse = true;
            code = {'error'};
        end
        
    else
        code = codeRaw;
    end
    
    f = codesplit(code);
    d(i).lines = zeros(size(f));
    
    for j = 1:length(f)
        nLines = nLines + 1;
        allLineList_non_unique{end+1} = strtrim(f{j});
        d(i).lines(j) = nLines;
    end
end
close(db)

[allLineList,~,ix] = unique(allLineList_non_unique);
firstTimeIndexList = zeros(size(allLineList));
lastTimeIndexList = zeros(size(allLineList));
% Count backwards so we get the first reference by the time the loop is
% complete.
for i = length(d):-1:1
    d(i).lines = ix(d(i).lines);
    firstTimeIndexList(d(i).lines) = i;
end

for i = 1:length(d)
    d(i).new_lines = d(i).lines(find(firstTimeIndexList(d(i).lines)==i));
    lastTimeIndexList(d(i).lines) = i;
end

dOut = d;

