function a = authorSharePlot(d,firstTimeIndexList)

% The authorMap maps from entry_id to author_id
authorMap = [d.author_id];

authorsOfAllEntries = [d.author_id];
[~,ix] = unique(authorsOfAllEntries,'first');
% This keeps the authors in order of first appearance
authorList = authorsOfAllEntries(ix);
numAuthors = length(authorList);
numEntries = length(d);
a = zeros(numAuthors,numEntries);

for entryCount = 1:numEntries
    linesInLeader = d(entryCount).lines;
    entriesInLeader = firstTimeIndexList(linesInLeader);
    authorsInLeader = authorMap(entriesInLeader);
        
    for authorCount = 1:numAuthors        
        a(authorCount,entryCount) = sum(authorsInLeader==authorList(authorCount));
    end
end

area(a')
xlim([0 numEntries])
xlabel('Index of the Current Leading Entry')
ylabel('Number of Lines in the Leading Entry')

legendStr = cellfun(@num2str,num2cell(authorList),'UniformOutput',false);
legend(legendStr,'Location','EastOutside','FontSize',6)
