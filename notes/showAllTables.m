%% Show All Tables
% This function displays all the tables in the contest database.

%% Connect to the Contest Database

db = connectToContestDatabase;

fprintf('Today''s date is %s\n', datestr(now,1));

%%

getdbtables(db)

%%

query = 'SELECT ALL id,title FROM contests';
r = queryDatabase(db, query);

for i = 1:length(r)
    fprintf('%2d. %s\n',r{i,1},r{i,2})
end

%%

close(db)