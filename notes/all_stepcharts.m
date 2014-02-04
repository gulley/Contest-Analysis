%% Make all step charts

fprintf('Published from file %s on %s\n',mfilename,datestr(now,1));

%%
% Stepcharts are used to give a qualitative understanding of the activity
% of the contest. 
%
% <<stepchart_explanation.png>>

%%

contestStruct = getContestMetaData;

%%

for i = 1:length(contestStruct)
    d = getContestData(contestStruct(i).id);
    d = rankAtDebut(d);
    
    leaders = find([d.initial_rank]==1);
    d2 = d(leaders);
    cleanFlag = false;
    d2Out = hashFiles(d2,cleanFlag);
    
    % Remove any entries that failed to parse
    if isfield(d2Out,'failedToParse')
        d2Out([d2Out.failedToParse]==true) = [];
    end
    
    subplot(2,1,1)
    stepchart(d2Out,'timestamp')
    title([contestStruct(i).name ' - raw code - timestamp'])
    
    subplot(2,1,2)
    stepchart(d2Out,'ordinal')
    title([contestStruct(i).name ' - raw code - ordinal'])
    snapnow
    
end