%% Author by Area
% These are area plots that show the "market share" of each author by
% contest.

fprintf('Published from file %s on %s\n',mfilename,datestr(now,1));

contestStruct = getContestMetaData;

for i = 1:length(contestStruct)
    
    contestName = contestStruct(i).name;
    
    d = getContestData(contestStruct(i).id);
    d = rankAtDebut(d);
    leaders = find([d.initial_rank]==1);
    d2 = d(leaders);
    cleanFlag = false;
    [d3, allLineList, firstTimeIndexList] = hashFiles(d2,cleanFlag);
    
    a = authorSharePlot(d3,firstTimeIndexList);
    
    title(contestStruct(i).name)
    
    snapnow
    
end
