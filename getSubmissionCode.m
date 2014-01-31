function code = getSubmissionCode(id,db)
%   getSubmissionCode(id,db)

if nargin<2
    temporaryConnection = true;
else
    temporaryConnection = false;
end

subStr = sprintf('submissions.id = %d ', id);
query = [ ...
    'SELECT codes.body ' ...
    'FROM codes,submissions ' ...
    'WHERE ' ...
    subStr ...
    'AND ' ...
    'codes.submission_id=submissions.id '];

if temporaryConnection
    db = connectToContestDatabase;
end

curs = exec(db,query);
error(curs.Message);
curs = fetch(curs);
error(curs.Message)
data = curs.Data;

if temporaryConnection
    close(db);
end

code = data{1};
