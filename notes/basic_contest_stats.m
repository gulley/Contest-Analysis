%% Basic Contest Statistics
% <http://www.mathworks.com/matlabcentral/contest/>

fprintf('Published from file %s on %s\n',mfilename,datestr(now,1));

%%

% These are all the contests in the correct chronological order
contestIdList = getAllContestIds;

query = 'SELECT ALL id,title FROM contests';
db = connectToContestDatabase;
names = queryDatabase(db, query);
close(db)

%%

data = [];
for i = 1:length(contestIdList)
    d = getContestData(contestIdList(i));
    
    % Remove the entries that failed the test suite
    d = d([d.passed]);
    
    d = rankAtDebut(d);
    
    contestName = names{contestIdList(i),2};    
    
    timeplot(d)
    title([contestName ' '  datestr(d(1).t,1)] );
    box on
    snapnow
    
    leaders = find([d.initial_rank]==1);
    len = length(d);
    fprintf('Name: %s\n', contestName)
    fprintf('Time of first entry: %s\n', datestr(d(1).t));
    fprintf('Time of last entry: %s\n', datestr(d(end).t));
    numAuthors = length(unique([d.author_id]));
    fprintf('Number of Players: %d\n',numAuthors);
    fprintf('Number of Entries: %d\n',len);
    fprintf('Entries per Player: %3.1f\n',len/numAuthors);
    fprintf('Number of Leading Entries: %d\n',length(leaders));
    numLeadingAuthors = length(unique([d(leaders).author_id]));
    fprintf('Number of Leading Players: %d\n',numLeadingAuthors);
    fprintf('Players per Leading Player: %3.1f\n',numAuthors/numLeadingAuthors);
    fprintf('Leader Percentage: %3.1f%%\n',length(leaders)/len*100);
    num_passed = sum([d.passed]==1);
    fprintf('Passing Entries: %d\n',num_passed);
    fprintf('Passing Percentage: %3.1f%%\n',num_passed/len*100);
        
end