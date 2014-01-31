%% Connect to the Contest Database

%%
% This code shows where the driver is maintained
% javaaddpath('\\mathworks\public\Kunal_Kadakia\MySQL_Driver\mysql-connector-java-5.1.13\mysql-connector-java-5.1.13-bin.jar');

db = database( ...
    'contest','contest','c0pwd', ...
    'com.mysql.jdbc.Driver', ...
    'jdbc:mysql://cmtyreport:13306/'); 
disp(db.Message)

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