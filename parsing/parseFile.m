function node = parseFile( fileName )
    % Build a parse tree from a code file
    
    fid = fopen(fileName,'r');
    
    if fid == -1
        fileName = which(fileName);
        fid = fopen(fileName,'r');
    end
    
    if fid == -1
        error('Can''t find the file %s.',fileName);
    end
    
    % load the file into a string
    fileContents = fread(fid,inf,'char=>char');
    fclose(fid);
    
    % and parse the string
    node = parseString(fileContents);
end

