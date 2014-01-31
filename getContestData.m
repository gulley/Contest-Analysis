function d = getContestData(contest_identifier,db)
%getContestData  Get the data associated with a contest from the database
%   d = getContestData(contest_identifier,db)
%   d = getContestData(contest_identifier)
%   contest_identifier is a numerical contest ID.

if nargin<2
    temporaryConnection = true;
else
    temporaryConnection = false;
end

contestStr = sprintf('contests.id = %d', contest_identifier);

query = [ ...
    'SELECT ALL ' ...
    'submissions.score, ' ...
    'submissions.created_at,' ...
    'submissions.title, ' ...
    'submissions.contributor_id,' ...
    'submissions.result, ' ...
    'submissions.cpu, ' ...
    'submissions.id, ' ...
    'submissions.submission_id, ' ...
    'submissions.initial_rank, ' ...
    'submissions.status ' ...
    'FROM ' ...
    'contests,submissions ' ...
    'WHERE ' ...
    'submissions.contest_id = contests.id ' ...
    'AND ' ...
    contestStr];

% 'submissions.scored_at, ' ...

if temporaryConnection
    db = connectToContestDatabase;
    results = queryDatabase(db,query);
    close(db)
else
    results = queryDatabase(db,query);
end

d = struct([]);

for i = 1:size(results,1)
    d(i).score        = results{i,1};
    d(i).t            = datenum(results{i,2});
    d(i).title        = results{i,3};
    d(i).author_id    = results{i,4};
    d(i).result       = results{i,5};
    d(i).cpu          = results{i,6};
    d(i).id           = results{i,7};
    d(i).parent       = results{i,8};
    d(i).initial_rank = results{i,9};
    if strcmp(results{i,10},'Passed')
        d(i).passed   = true;
    else
        d(i).passed   = false;
    end
end

if contest_identifier==3
    d(1).t = datenum('1998-12-14 12:00:00');
end
