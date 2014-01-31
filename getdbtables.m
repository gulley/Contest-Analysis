function getdbtables(conn)
%GETDBTABLES Display database tables
%   getdbtables(conn)
%   Get the tables from the database associated with the connection conn

d = dmd(conn);
ctg = get(conn,'Catalog');
tinfo = tables(d,ctg,'');

for n = 1:size(tinfo,1),
    table = tinfo{n,1};
    % The "limit 1" construct is from MySQL
    ex = exec(conn,['select * from ' table ' limit 1']);
    ex = fetch(ex,1);
    a = attr(ex);
    tabfields = {a.fieldName};
    close(ex);
    
    fprintf(1,'\nTABLE: %s\n',table);
    for m = 1:length(tabfields),
        fprintf(1,'   %s\n',tabfields{m});
    end
end


