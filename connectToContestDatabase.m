function db = connectToContestDatabase
%connectToContestDatabase

% This code shows where to find the MySQL driver
% javaaddpath('\\mathworks\public\Kunal_Kadakia\MySQL_Driver\mysql-connector-java-5.1.13\mysql-connector-java-5.1.13-bin.jar');

% Connect to the Contest Database
% This is a read-only connection.
db = database( ...
    'contest','contest','c0pwd', ...
    'com.mysql.jdbc.Driver', ...
    'jdbc:mysql://cmtyreport:13306/');
disp(db.Message)

